import Foundation

@MainActor
final class TransactionDetailViewModel: ObservableObject {
    @Published var transaction: Transaction?
    @Published var errorMessage: String?

    func bind(transactionId: String, source: [Transaction]) {
        transaction = source.first(where: { $0.id == transactionId })
        if transaction == nil { errorMessage = "Transaction not found." }
    }
}
