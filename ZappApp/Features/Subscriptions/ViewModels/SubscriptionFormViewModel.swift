import Foundation

@MainActor
final class SubscriptionFormViewModel: ObservableObject {
    @Published private(set) var existingBackendID: String?
    @Published var merchant = ""
    @Published var amount = ""
    @Published var cycle: BillingCycle = .monthly
    @Published var startDate = ""
    @Published var notes = ""
    @Published var errorMessage: String?

    func load(existing: Subscription?) {
        guard let existing else { return }
        existingBackendID = existing.backendID
        merchant = existing.merchant
        amount = String(existing.amount)
        cycle = existing.billingCycle
        startDate = existing.startedAt
        notes = existing.notes ?? ""
    }

    func build(existingId: UUID?) -> Subscription? {
        guard !merchant.isEmpty, let amountValue = Double(amount), !startDate.isEmpty else {
            errorMessage = "Merchant, amount, and start date are required."
            return nil
        }
        errorMessage = nil
        return Subscription(
            id: existingId ?? UUID(),
            backendID: existingBackendID,
            merchant: merchant,
            amount: amountValue,
            currency: "USD",
            billingCycle: cycle,
            status: .active,
            startedAt: startDate,
            notes: notes,
            valuation: SubscriptionValuation(valueScore: 75, explanation: "Usage and cost remain balanced.", confidence: 0.79)
        )
    }
}
