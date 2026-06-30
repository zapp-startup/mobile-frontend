import Foundation

@MainActor
final class SubscriptionDetailViewModel: ObservableObject {
    @Published var subscription: Subscription?
    @Published var errorMessage: String?

    func bind(subscriptionId: UUID, source: [Subscription]) {
        subscription = source.first(where: { $0.id == subscriptionId })
        if subscription == nil {
            errorMessage = "Subscription not found."
        }
    }
}
