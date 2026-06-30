import Foundation

struct BuyAdvisorRequest: Codable, Hashable {
    var predictedPrice: Double
    var category: String
}

struct BuyAdvisorResponse: Codable, Hashable {
    var recommendation: String
    var valueScore: Int
    var rationale: String
    var confidence: Double
}
