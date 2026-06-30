import Foundation

@MainActor
final class MonthlyReviewViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var review: Review?
    @Published var showReflection = false
    @Published var reflectionTargetTransactionID: String?

    private let service: ReviewsService
    private let transactionsService: TransactionsService

    init(
        service: ReviewsService = ReviewsService(),
        transactionsService: TransactionsService = TransactionsService()
    ) {
        self.service = service
        self.transactionsService = transactionsService
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            review = try await service.fetchMonthlyReview()
            let candidates = try? await transactionsService.fetchFeedbackCandidates(n: 1, days: 60)
            reflectionTargetTransactionID = candidates?.first?.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submit(summary: [UUID: String]) async {
        do {
            let payload = Dictionary(uniqueKeysWithValues: summary.map { ($0.key.uuidString, $0.value) })
            try await service.completeMonthly(summary: payload, notes: nil)
            successMessage = "Monthly review submitted."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveReflection(_ feedback: TransactionFeedback) async {
        guard let transactionID = reflectionTargetTransactionID else {
            errorMessage = "No transaction candidate available for reflection."
            return
        }
        do {
            try await service.createReflection(transactionID: transactionID, feedback: feedback)
            successMessage = "Reflection saved."
            showReflection = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
