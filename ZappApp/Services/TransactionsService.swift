import Foundation

final class TransactionsService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchTransactions(limit: Int? = nil) async throws -> [Transaction] {
        var query: [URLQueryItem] = []
        if let limit {
            query.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        let payload: [TransactionResponse] = try await apiClient.request(Endpoint.get("/api/transactions/", queryItems: query))
        return payload.map { $0.toTransaction() }
    }

    func createTransaction(_ transaction: Transaction) async throws -> Transaction {
        let payload: TransactionResponse = try await apiClient.request(
            Endpoint.post("/api/transactions/"),
            body: CreateTransactionRequest.fromTransaction(transaction)
        )
        return payload.toTransaction()
    }

    func updateTransaction(_ transaction: Transaction) async throws -> Transaction {
        let payload: TransactionResponse = try await apiClient.request(
            Endpoint.patch("/api/transactions/\(transaction.id)/"),
            body: UpdateTransactionRequest.fromTransaction(transaction)
        )
        return payload.toTransaction()
    }

    func deleteTransaction(id: String) async throws {
        let _: EmptyResponse = try await apiClient.request(Endpoint.delete("/api/transactions/\(id)/"))
    }

    func submitFeedback(transactionId: String, feedback: TransactionFeedback) async throws -> Transaction {
        let payload: TransactionResponse = try await apiClient.request(
            Endpoint.patch("/api/transactions/\(transactionId)/"),
            body: TransactionFeedbackPatchRequest.fromFeedback(feedback)
        )
        return payload.toTransaction()
    }

    func score(transactionId: String) async throws -> Transaction {
        let payload: TransactionResponse = try await apiClient.request(Endpoint.post("/api/transactions/\(transactionId)/score/"))
        return payload.toTransaction()
    }

    func fetchFeedbackCandidates(n: Int = 5, days: Int = 30) async throws -> [Transaction] {
        let payload: [TransactionResponse] = try await apiClient.request(
            Endpoint.get(
                "/api/transactions/feedback-candidates/",
                queryItems: [
                    URLQueryItem(name: "n", value: String(n)),
                    URLQueryItem(name: "days", value: String(days))
                ]
            )
        )
        return payload.map { $0.toTransaction() }
    }
}

private struct TransactionResponse: Decodable {
    let id: FlexibleIdentifier
    let description: String?
    let merchant: String?
    let category: String?
    let amount: Double?
    let currency: String?
    let direction: String?
    let date: String?
    let createdAt: String?
    let updatedAt: String?
    let valueScore: Int?
    let satisfaction: Int?
    let regretScore: Int?
    let repurchaseLikelihood: Int?
    let usageFrequency: String?
    let reflection: String?
    let paymentChannel: String?
    let bankTransaction: FlexibleIdentifier?

    func toTransaction() -> Transaction {
        let directionValue = direction ?? "spend"
        let txType = TransactionType(rawValue: directionValue) ?? .spend
        return Transaction(
            id: id.stringValue,
            description: description ?? merchant ?? "Transaction",
            merchant: merchant ?? "Unknown Merchant",
            category: category ?? "other",
            amount: amount ?? 0,
            currency: currency ?? "USD",
            type: txType,
            date: date ?? "",
            valueScore: valueScore,
            satisfaction: satisfaction,
            feedback: TransactionFeedback(
                satisfaction: satisfaction,
                regretScore: regretScore,
                repurchaseLikelihood: repurchaseLikelihood,
                usageFrequency: usageFrequency,
                reflection: reflection
            ),
            source: bankTransaction == nil ? "manual" : "bank",
            createdAt: createdAt ?? "",
            updatedAt: updatedAt ?? "",
            backendDirection: directionValue,
            paymentChannel: paymentChannel
        )
    }
}

private struct CreateTransactionRequest: Encodable {
    let description: String
    let merchant: String
    let category: String
    let amount: Double
    let currency: String
    let direction: String
    let date: String
    let paymentChannel: String

    static func fromTransaction(_ transaction: Transaction) -> CreateTransactionRequest {
        CreateTransactionRequest(
            description: transaction.description,
            merchant: transaction.merchant,
            category: transaction.category,
            amount: transaction.amount,
            currency: transaction.currency,
            direction: transaction.type.apiDirection,
            date: normalizedDate(transaction.date),
            paymentChannel: transaction.paymentChannel ?? "card"
        )
    }

    static func normalizedDate(_ value: String) -> String {
        if value.contains("T") {
            return value
        }
        return "\(value)T12:00:00Z"
    }
}

private struct UpdateTransactionRequest: Encodable {
    let description: String
    let merchant: String
    let category: String
    let amount: Double
    let direction: String
    let date: String
    let satisfaction: Int?

    static func fromTransaction(_ transaction: Transaction) -> UpdateTransactionRequest {
        UpdateTransactionRequest(
            description: transaction.description,
            merchant: transaction.merchant,
            category: transaction.category,
            amount: transaction.amount,
            direction: transaction.type.apiDirection,
            date: CreateTransactionRequest.normalizedDate(transaction.date),
            satisfaction: transaction.satisfaction
        )
    }
}

private struct TransactionFeedbackPatchRequest: Encodable {
    let satisfaction: Int?
    let regretScore: Int?
    let repurchaseLikelihood: Int?
    let usageFrequency: String?
    let reflection: String?

    static func fromFeedback(_ feedback: TransactionFeedback) -> TransactionFeedbackPatchRequest {
        TransactionFeedbackPatchRequest(
            satisfaction: feedback.satisfaction,
            regretScore: feedback.regretScore,
            repurchaseLikelihood: feedback.repurchaseLikelihood,
            usageFrequency: feedback.usageFrequency,
            reflection: feedback.reflection
        )
    }
}
