import Foundation

enum ReviewPeriod: String, Codable, Hashable {
    case weekly
    case monthly
}

struct ReviewPrompt: Codable, Identifiable, Hashable {
    let id: UUID
    var question: String
    var answer: String?
}

struct Review: Codable, Identifiable, Hashable {
    let id: UUID
    var period: ReviewPeriod
    var reviewedCount: Int
    var pendingCount: Int
    var prompts: [ReviewPrompt]
    var reflections: [TransactionFeedback]
    var submittedAt: String?
}
