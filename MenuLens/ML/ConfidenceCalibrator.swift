import Foundation

// MARK: - Confidence Calibrator
/// Calibrates raw ML model confidence scores using Platt scaling
/// to produce well-calibrated probability estimates for menu OCR results.

struct CalibrationResult {
    let originalConfidence: Double
    let calibratedConfidence: Double
    let reliabilityBucket: ReliabilityBucket
    
    enum ReliabilityBucket: String, CaseIterable {
        case high = "high"       // >= 0.85
        case medium = "medium"   // >= 0.60
        case low = "low"         // >= 0.30
        case unreliable = "unreliable" // < 0.30
        
        init(confidence: Double) {
            switch confidence {
            case 0.85...: self = .high
            case 0.60..<0.85: self = .medium
            case 0.30..<0.60: self = .low
            default: self = .unreliable
            }
        }
    }
}

final class ConfidenceCalibrator {
    
    // Platt scaling parameters (learned from validation set)
    private var plattA: Double = -1.0
    private var plattB: Double = 0.0
    
    // Histogram binning for reliability diagram
    private let numBins: Int
    private var binAccuracies: [Double]
    private var binCounts: [Int]
    
    init(numBins: Int = 10) {
        self.numBins = numBins
        self.binAccuracies = Array(repeating: 0.0, count: numBins)
        self.binCounts = Array(repeating: 0, count: numBins)
    }
    
    // MARK: - Platt Scaling
    
    /// Calibrate a raw confidence score using sigmoid (Platt) scaling.
    func calibrate(_ rawConfidence: Double) -> CalibrationResult {
        let calibrated = plattTransform(rawConfidence)
        let clamped = min(max(calibrated, 0.0), 1.0)
        return CalibrationResult(
            originalConfidence: rawConfidence,
            calibratedConfidence: clamped,
            reliabilityBucket: .init(confidence: clamped)
        )
    }
    
    /// Batch calibrate multiple scores.
    func calibrateBatch(_ scores: [Double]) -> [CalibrationResult] {
        scores.map { calibrate($0) }
    }
    
    // MARK: - Training
    
    /// Fit Platt scaling parameters from validation data.
    /// - Parameters:
    ///   - predictions: Raw model confidence scores
    ///   - labels: Ground truth (1.0 = correct, 0.0 = incorrect)
    func fit(predictions: [Double], labels: [Double]) {
        guard predictions.count == labels.count, predictions.count >= 5 else { return }
        
        // Gradient descent for logistic regression on log-odds
        var a = -1.0
        var b = 0.0
        let lr = 0.01
        let iterations = 1000
        
        for _ in 0..<iterations {
            var gradA = 0.0
            var gradB = 0.0
            
            for i in 0..<predictions.count {
                let z = a * predictions[i] + b
                let p = 1.0 / (1.0 + exp(-z))
                let error = p - labels[i]
                gradA += error * predictions[i]
                gradB += error
            }
            
            let n = Double(predictions.count)
            a -= lr * gradA / n
            b -= lr * gradB / n
        }
        
        plattA = a
        plattB = b
        
        // Update histogram bins
        updateBins(predictions: predictions, labels: labels)
    }
    
    // MARK: - Metrics
    
    /// Expected Calibration Error — measures how well-calibrated the model is.
    func expectedCalibrationError() -> Double {
        let totalSamples = binCounts.reduce(0, +)
        guard totalSamples > 0 else { return 1.0 }
        
        var ece = 0.0
        for i in 0..<numBins {
            guard binCounts[i] > 0 else { continue }
            let binCenter = (Double(i) + 0.5) / Double(numBins)
            let weight = Double(binCounts[i]) / Double(totalSamples)
            ece += weight * abs(binAccuracies[i] - binCenter)
        }
        return ece
    }
    
    /// Temperature scaling — simple single-parameter calibration.
    static func temperatureScale(_ logits: [Double], temperature: Double) -> [Double] {
        let scaled = logits.map { $0 / max(temperature, 1e-8) }
        let maxVal = scaled.max() ?? 0
        let exps = scaled.map { exp($0 - maxVal) }
        let sumExps = exps.reduce(0, +)
        return exps.map { $0 / sumExps }
    }
    
    // MARK: - Private
    
    private func plattTransform(_ x: Double) -> Double {
        1.0 / (1.0 + exp(-(plattA * x + plattB)))
    }
    
    private func updateBins(predictions: [Double], labels: [Double]) {
        binAccuracies = Array(repeating: 0.0, count: numBins)
        binCounts = Array(repeating: 0, count: numBins)
        var binCorrect = Array(repeating: 0.0, count: numBins)
        
        for i in 0..<predictions.count {
            let binIdx = min(Int(predictions[i] * Double(numBins)), numBins - 1)
            binCounts[binIdx] += 1
            binCorrect[binIdx] += labels[i]
        }
        
        for i in 0..<numBins {
            if binCounts[i] > 0 {
                binAccuracies[i] = binCorrect[i] / Double(binCounts[i])
            }
        }
    }
}
