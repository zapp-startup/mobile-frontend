import Foundation

struct AnalyticsMetric: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var title: String
    var value: String
    var delta: String
}

struct ValuationInput: Codable, Hashable {
    var description: String
    var amount: Double
}

struct ValuationResult: Codable, Hashable {
    var computedOutputs: [String: Double]
    var inferredValues: [String: Double]
    var valueOutputs: [String: Double]
    var insights: [String]
}
