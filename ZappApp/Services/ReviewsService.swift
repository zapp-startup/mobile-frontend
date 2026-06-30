import Foundation

final class ReviewsService {
    private let circlesService: CirclesService

    init(circlesService: CirclesService = CirclesService()) {
        self.circlesService = circlesService
    }

    func fetchWeeklyReview() async throws -> Review {
        try await circlesService.fetchWeeklyReview()
    }

    func fetchMonthlyReview() async throws -> Review {
        try await circlesService.fetchMonthlyReview()
    }

    func completeWeekly(summary: [String: String], notes: String?) async throws {
        try await circlesService.completeWeeklyReview(summary: summary, notes: notes)
    }

    func completeMonthly(summary: [String: String], notes: String?) async throws {
        try await circlesService.completeMonthlyReview(summary: summary, notes: notes)
    }

    func createReflection(transactionID: String, feedback: TransactionFeedback) async throws {
        try await circlesService.createReflection(transactionID: transactionID, feedback: feedback)
    }
}
