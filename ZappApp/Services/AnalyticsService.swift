import Foundation

final class AnalyticsService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchMetrics() async throws -> [AnalyticsMetric] {
        async let inferredTask: [AnalyticsObjectResponse] = apiClient.request(Endpoint.get("/api/raw-inferred/"))
        async let computedTask: [AnalyticsObjectResponse] = apiClient.request(Endpoint.get("/api/computed/"))
        async let subscriptionValuationsTask: [AnalyticsValuationResponse] = apiClient.request(Endpoint.get("/api/subscription-valuations/"))
        async let itemValuationsTask: [AnalyticsValuationResponse] = apiClient.request(Endpoint.get("/api/item-valuations/"))

        let (inferred, computed, subscriptionValuations, itemValuations) = try await (
            inferredTask,
            computedTask,
            subscriptionValuationsTask,
            itemValuationsTask
        )

        let inferredCount = inferred.first?.asDictionary().count ?? 0
        let computedCount = computed.first?.asDictionary().count ?? 0
        let avgScore = averageScore(from: subscriptionValuations + itemValuations)

        return [
            AnalyticsMetric(
                id: stableAnalyticsUUID("inferred"),
                backendID: "raw_inferred",
                title: "Inferred Signals",
                value: "\(inferredCount)",
                delta: inferredCount > 0 ? "Loaded" : "No data"
            ),
            AnalyticsMetric(
                id: stableAnalyticsUUID("computed"),
                backendID: "computed",
                title: "Computed Outputs",
                value: "\(computedCount)",
                delta: computedCount > 0 ? "Loaded" : "No data"
            ),
            AnalyticsMetric(
                id: stableAnalyticsUUID("valuation"),
                backendID: "valuations",
                title: "Avg Value Score",
                value: String(format: "%.1f", avgScore),
                delta: "\(subscriptionValuations.count + itemValuations.count) valuations"
            )
        ]
    }

    func computeValuation(input: ValuationInput) async throws -> ValuationResult {
        let _: AnalyticsValuationCreateResponse = try await apiClient.request(
            Endpoint.post("/api/item-valuations/"),
            body: AnalyticsValuationCreateRequest(itemName: input.description, observedPrice: input.amount)
        )

        async let inferredTask: [AnalyticsObjectResponse] = apiClient.request(Endpoint.get("/api/raw-inferred/"))
        async let computedTask: [AnalyticsObjectResponse] = apiClient.request(Endpoint.get("/api/computed/"))
        async let itemValuationsTask: [AnalyticsValuationResponse] = apiClient.request(Endpoint.get("/api/item-valuations/"))

        let (inferred, computed, itemValuations) = try await (inferredTask, computedTask, itemValuationsTask)
        let computedOutputs = computed.first?.asDoubleDictionary() ?? [:]
        let inferredValues = inferred.first?.asDoubleDictionary() ?? [:]
        let valueOutputs = [
            "latest_score": itemValuations.first?.valueScore ?? 0,
            "confidence": itemValuations.first?.confidence ?? 0
        ]
        let insights = itemValuations.prefix(3).map { $0.recommendation ?? "No recommendation provided." }
        return ValuationResult(
            computedOutputs: computedOutputs,
            inferredValues: inferredValues,
            valueOutputs: valueOutputs,
            insights: insights.isEmpty ? ["Valuation created successfully."] : insights
        )
    }

    private func averageScore(from valuations: [AnalyticsValuationResponse]) -> Double {
        let scores = valuations.map(\.valueScore).filter { $0 > 0 }
        guard !scores.isEmpty else { return 0 }
        return scores.reduce(0, +) / Double(scores.count)
    }
}

private struct AnalyticsObjectResponse: Decodable {
    let id: FlexibleIdentifier?
    let payload: [String: Double]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let raw = try? container.decode([String: Double].self) {
            id = nil
            payload = raw
            return
        }
        let dictionary = try container.decode([String: JSONValue].self)
        id = dictionary["id"]?.asFlexibleIdentifier()
        var doubles: [String: Double] = [:]
        for (key, value) in dictionary {
            if let number = value.asDouble() {
                doubles[key] = number
            }
        }
        payload = doubles
    }

    func asDictionary() -> [String: Double] { payload }
    func asDoubleDictionary() -> [String: Double] { payload }
}

private struct AnalyticsValuationResponse: Decodable {
    let id: FlexibleIdentifier?
    let valueScore: Double
    let confidence: Double
    let recommendation: String?
}

private struct AnalyticsValuationCreateRequest: Encodable {
    let itemName: String
    let observedPrice: Double
}

private struct AnalyticsValuationCreateResponse: Decodable {
    let id: FlexibleIdentifier?
}

private enum JSONValue: Decodable {
    case string(String)
    case number(Double)
    case int(Int)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON type")
        }
    }

    func asDouble() -> Double? {
        switch self {
        case .number(let value):
            return value
        case .int(let value):
            return Double(value)
        default:
            return nil
        }
    }

    func asFlexibleIdentifier() -> FlexibleIdentifier? {
        switch self {
        case .int(let value):
            return .int(value)
        case .string(let value):
            return .string(value)
        default:
            return nil
        }
    }
}

private func stableAnalyticsUUID(_ seed: String) -> UUID {
    var hash: UInt64 = 0xcbf29ce484222325
    for byte in seed.utf8 {
        hash = (hash ^ UInt64(byte)) &* 0x100000001b3
    }
    let hex = String(format: "%016llx%016llx", hash, hash ^ 0xa24baed4963ee407)
    let formatted = "\(hex.prefix(8))-\(hex.dropFirst(8).prefix(4))-\(hex.dropFirst(12).prefix(4))-\(hex.dropFirst(16).prefix(4))-\(hex.dropFirst(20).prefix(12))"
    return UUID(uuidString: formatted) ?? UUID()
}
