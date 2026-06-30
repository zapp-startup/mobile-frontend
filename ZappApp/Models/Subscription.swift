import Foundation

enum BillingCycle: String, Codable, CaseIterable, Hashable {
    case weekly
    case monthly
    case quarterly
    case yearly
}

enum SubscriptionStatus: String, Codable, CaseIterable, Hashable {
    case active
    case paused
    case canceled
}

struct SubscriptionValuation: Codable, Hashable {
    var valueScore: Int
    var explanation: String
    var confidence: Double
}

struct Subscription: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var merchant: String
    var amount: Double
    var currency: String
    var billingCycle: BillingCycle
    var status: SubscriptionStatus
    var startedAt: String
    var notes: String?
    var valuation: SubscriptionValuation?
}
