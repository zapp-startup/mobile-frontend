import Foundation

@MainActor
final class TransactionFormViewModel: ObservableObject {
    @Published var description = ""
    @Published var merchant = ""
    @Published var amount = ""
    @Published var category = ""
    @Published var type: TransactionType = .spend
    @Published var date = ""
    @Published var satisfaction = ""
    @Published var errorMessage: String?

    func load(existing: Transaction?) {
        guard let existing else { return }
        description = existing.description
        merchant = existing.merchant
        amount = String(existing.amount)
        category = existing.category
        type = existing.type
        date = existing.date
        satisfaction = existing.satisfaction.map(String.init) ?? ""
    }

    func build(existingId: String?) -> Transaction? {
        guard let amountValue = Double(amount), !description.isEmpty, !merchant.isEmpty, !category.isEmpty, !date.isEmpty else {
            errorMessage = "Please complete all required fields."
            return nil
        }
        errorMessage = nil
        return Transaction(
            id: existingId ?? "",
            description: description,
            merchant: merchant,
            category: category,
            amount: amountValue,
            currency: "USD",
            type: type,
            date: date,
            valueScore: 70,
            satisfaction: Int(satisfaction),
            feedback: nil,
            source: "manual",
            createdAt: MockSeed.isoNow,
            updatedAt: MockSeed.isoNow,
            backendDirection: type.rawValue,
            paymentChannel: "card"
        )
    }
}
