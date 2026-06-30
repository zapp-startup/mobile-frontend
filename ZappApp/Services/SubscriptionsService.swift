import Foundation

struct Merchant: Codable, Hashable, Identifiable {
    let id: String
    let name: String
}

final class SubscriptionsService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchSubscriptions() async throws -> [Subscription] {
        let payload: [SubscriptionResponse] = try await apiClient.request(Endpoint.get("/api/subscriptions/"))
        return payload.map { $0.toSubscription() }
    }

    func fetchMerchants() async throws -> [Merchant] {
        let response: MerchantsListResponse = try await apiClient.request(Endpoint.get("/api/merchants/"))
        return response.merchants
    }

    func fetchSubscriptionValuations() async throws -> [SubscriptionValuationRecord] {
        let payload: [SubscriptionValuationResponse] = try await apiClient.request(Endpoint.get("/api/subscription-valuations/"))
        return payload.map {
            SubscriptionValuationRecord(
                subscriptionBackendID: $0.subscription.stringValue,
                valueScore: Int(($0.valueScore ?? 0).rounded()),
                confidence: $0.confidence ?? 0,
                explanation: $0.recommendation ?? "No recommendation"
            )
        }
    }

    func recomputeValueScores() async throws {
        let _: EmptyResponse = try await apiClient.request(Endpoint.post("/api/value-scores/recompute/"))
    }

    func saveSubscription(_ subscription: Subscription) async throws -> Subscription {
        let merchantName = try await bestMatchingMerchantName(for: subscription.merchant)
        let request = SubscriptionUpsertRequest.from(subscription: subscription, merchantName: merchantName)
        let response: SubscriptionResponse
        if let backendID = subscription.backendID, !backendID.isEmpty {
            response = try await apiClient.request(
                Endpoint.patch("/api/subscriptions/\(backendID)/"),
                body: request
            )
        } else {
            response = try await apiClient.request(Endpoint.post("/api/subscriptions/"), body: request)
        }
        return response.toSubscription()
    }

    func deleteSubscription(id: UUID) async throws {
        let subscriptions = try await fetchSubscriptions()
        guard let backendID = subscriptions.first(where: { $0.id == id })?.backendID else {
            throw APIError.server(statusCode: 404, message: "Subscription not found on backend.")
        }
        let _: EmptyResponse = try await apiClient.request(
            Endpoint.delete("/api/subscriptions/\(backendID)/")
        )
    }

    func bestMatchingMerchantName(for input: String) async throws -> String {
        let merchants = try await fetchMerchants()
        let normalized = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return input }

        if let exact = merchants.first(where: { $0.name.lowercased() == normalized }) {
            return exact.name
        }

        if let contains = merchants.first(where: { $0.name.lowercased().contains(normalized) || normalized.contains($0.name.lowercased()) }) {
            return contains.name
        }
        return input
    }

}

private struct SubscriptionUpsertRequest: Encodable {
    let merchant: String
    let price: Double
    let billingCycle: String
    let status: String
    let startedOn: String
    let notes: String?

    static func from(subscription: Subscription, merchantName: String) -> SubscriptionUpsertRequest {
        SubscriptionUpsertRequest(
            merchant: merchantName,
            price: subscription.amount,
            billingCycle: subscription.billingCycle.rawValue,
            status: subscription.status.rawValue,
            startedOn: subscription.startedAt.prefix(10).description,
            notes: subscription.notes
        )
    }
}

private struct SubscriptionResponse: Decodable {
    let id: FlexibleIdentifier
    let merchant: String?
    let price: Double?
    let billingCycle: String?
    let status: String?
    let startedOn: String?
    let notes: String?
    let latestValueScore: Double?
    let feedbackValueScore: Double?

    func toSubscription() -> Subscription {
        let value = latestValueScore ?? feedbackValueScore
        return Subscription(
            id: stableUUID(from: "sub-\(id.stringValue)"),
            backendID: id.stringValue,
            merchant: merchant ?? "Unknown Merchant",
            amount: price ?? 0,
            currency: "USD",
            billingCycle: BillingCycle(rawValue: billingCycle ?? "monthly") ?? .monthly,
            status: SubscriptionStatus(rawValue: status ?? "active") ?? .active,
            startedAt: startedOn?.contains("T") == true ? (startedOn ?? "") : "\(startedOn ?? "")T00:00:00Z",
            notes: notes,
            valuation: value.map {
                SubscriptionValuation(
                    valueScore: Int($0.rounded()),
                    explanation: "Derived from latest subscription valuation.",
                    confidence: 0.8
                )
            }
        )
    }
}

private struct SubscriptionValuationResponse: Decodable {
    let subscription: FlexibleIdentifier
    let valueScore: Double?
    let confidence: Double?
    let recommendation: String?
}

struct SubscriptionValuationRecord: Hashable {
    let subscriptionBackendID: String
    let valueScore: Int
    let confidence: Double
    let explanation: String
}

private struct MerchantsListResponse: Decodable {
    let merchants: [Merchant]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([MerchantResponse].self) {
            merchants = array.map { Merchant(id: $0.id.stringValue, name: $0.name) }
            return
        }
        let wrapped = try container.decode(MerchantWrappedResponse.self)
        if let results = wrapped.results {
            merchants = results.map { Merchant(id: $0.id.stringValue, name: $0.name) }
        } else if let data = wrapped.data {
            merchants = data.map { Merchant(id: $0.id.stringValue, name: $0.name) }
        } else {
            merchants = []
        }
    }
}

private struct MerchantWrappedResponse: Decodable {
    let results: [MerchantResponse]?
    let data: [MerchantResponse]?
}

private struct MerchantResponse: Decodable {
    let id: FlexibleIdentifier
    let name: String
}

private func stableUUID(from input: String) -> UUID {
    var hash: UInt64 = 1469598103934665603
    let prime: UInt64 = 1099511628211
    for byte in input.utf8 {
        hash ^= UInt64(byte)
        hash = hash &* prime
    }
    let hex = String(format: "%016llx%016llx", hash, hash ^ 0x9e3779b97f4a7c15)
    let formatted = "\(hex.prefix(8))-\(hex.dropFirst(8).prefix(4))-\(hex.dropFirst(12).prefix(4))-\(hex.dropFirst(16).prefix(4))-\(hex.dropFirst(20).prefix(12))"
    return UUID(uuidString: formatted) ?? UUID()
}
