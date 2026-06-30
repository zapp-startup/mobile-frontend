import Foundation

@MainActor
final class SubscriptionsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var subscriptions: [Subscription] = []

    private let service: SubscriptionsService

    init(service: SubscriptionsService = SubscriptionsService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let subs = service.fetchSubscriptions()
            async let valuations = service.fetchSubscriptionValuations()
            let (fetchedSubscriptions, fetchedValuations) = try await (subs, valuations)
            let valuationMap = Dictionary(uniqueKeysWithValues: fetchedValuations.map { ($0.subscriptionBackendID, $0) })
            subscriptions = fetchedSubscriptions.map { subscription in
                guard let backendID = subscription.backendID, let valuation = valuationMap[backendID] else {
                    return subscription
                }
                var enriched = subscription
                enriched.valuation = SubscriptionValuation(
                    valueScore: valuation.valueScore,
                    explanation: valuation.explanation,
                    confidence: valuation.confidence
                )
                return enriched
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func save(_ subscription: Subscription) async {
        do {
            let saved = try await service.saveSubscription(subscription)
            try? await service.recomputeValueScores()
            if let idx = subscriptions.firstIndex(where: { $0.id == saved.id }) {
                subscriptions[idx] = saved
            } else {
                subscriptions.insert(saved, at: 0)
            }
            successMessage = "Subscription saved."
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(id: UUID) async {
        do {
            try await service.deleteSubscription(id: id)
            subscriptions.removeAll { $0.id == id }
            successMessage = "Subscription deleted."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
