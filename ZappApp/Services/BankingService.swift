import Foundation

struct BankConnectionDetailPayload: Codable {
    var connection: BankConnection
    var accounts: [BankAccount]
    var transactions: [BankTransaction]
}

final class BankingService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchConnections() async throws -> [BankConnection] {
        let payload: [BankConnectionResponse] = try await apiClient.request(Endpoint.get("/api/banking/connections/"))
        return payload.map { $0.toBankConnection() }
    }

    func fetchAccounts() async throws -> [BankAccount] {
        let payload: [BankAccountResponse] = try await apiClient.request(Endpoint.get("/api/banking/accounts/"))
        return payload.map { $0.toBankAccount() }
    }

    func fetchTransactions(
        accountId: String? = nil,
        limit: Int? = nil
    ) async throws -> [BankTransaction] {
        var query: [URLQueryItem] = []
        if let accountId {
            query.append(URLQueryItem(name: "account_id", value: accountId))
        }
        if let limit {
            query.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        let payload: [BankTransactionResponse] = try await apiClient.request(
            Endpoint.get("/api/banking/transactions/", queryItems: query)
        )
        return payload.map { $0.toBankTransaction() }
    }

    func createLinkToken() async throws -> String {
        let response: LinkTokenResponse = try await apiClient.request(Endpoint.post("/api/banking/link-token/"))
        return response.linkToken
    }

    func exchangePublicToken(_ publicToken: String) async throws -> BankConnection {
        let response: ExchangeTokenResponse = try await apiClient.request(
            Endpoint.post("/api/banking/exchange-token/"),
            body: ExchangeTokenRequest(publicToken: publicToken, publicTokenCamelCase: publicToken)
        )
        return response.connection.toBankConnection()
    }

    func syncConnection(connectionId: String) async throws {
        let _: SyncResponse = try await apiClient.request(Endpoint.post("/api/banking/connections/\(connectionId)/sync/"))
    }

    func submitBankTransactionFeedback(transactionId: String, feedback: TransactionFeedback) async throws -> BankTransaction {
        let response: BankTransactionResponse = try await apiClient.request(
            Endpoint.patch("/api/banking/transactions/\(transactionId)/"),
            body: BankFeedbackPatchRequest.from(feedback)
        )
        return response.toBankTransaction()
    }

    func scoreBankTransaction(transactionId: String) async throws -> BankTransaction {
        let response: BankTransactionResponse = try await apiClient.request(
            Endpoint.post("/api/banking/transactions/\(transactionId)/score/")
        )
        return response.toBankTransaction()
    }
}

final class BankLinkCoordinator {
    private let bankingService: BankingService
    private let authService: AuthService
    private let complianceService: ComplianceService

    init(
        bankingService: BankingService = BankingService(),
        authService: AuthService = AuthService(),
        complianceService: ComplianceService = ComplianceService()
    ) {
        self.bankingService = bankingService
        self.authService = authService
        self.complianceService = complianceService
    }

    func prepareSecureLinking(consentText: String) async throws -> String {
        let assurance = try await authService.authAssurance()
        if assurance.mfaPending == true || assurance.mfaRequired == true || assurance.blockingCode == "mfa_required" {
            throw APIError.server(statusCode: 403, message: "MFA verification is required before linking a bank.", code: "mfa_required")
        }

        let consentStatus = try await complianceService.consentStatus()
        if consentStatus.hasValidConsent != true {
            try await complianceService.recordConsent(consentText: consentText)
        }

        // Re-check assurance after consent update to mirror web flow guardrails.
        let refreshedAssurance = try await authService.authAssurance()
        if refreshedAssurance.canLinkBank == false {
            throw APIError.server(
                statusCode: 403,
                message: "Additional security checks are required before bank linking.",
                code: refreshedAssurance.blockingCode
            )
        }

        return try await bankingService.createLinkToken()
    }

    func finalizeLink(publicToken: String) async throws -> BankConnection {
        try await bankingService.exchangePublicToken(publicToken)
    }
}

private struct LinkTokenResponse: Decodable {
    let linkToken: String
}

private struct ExchangeTokenRequest: Encodable {
    let publicToken: String
    let publicTokenCamelCase: String

    enum CodingKeys: String, CodingKey {
        case publicToken = "public_token"
        case publicTokenCamelCase = "publicToken"
    }
}

private struct ExchangeTokenResponse: Decodable {
    let success: Bool?
    let connection: BankConnectionResponse
}

private struct SyncResponse: Decodable {
    let success: Bool?
}

private struct BankConnectionResponse: Decodable {
    let id: FlexibleIdentifier
    let institutionName: String?
    let institutionId: String?
    let status: String?
    let lastSyncedAt: String?

    func toBankConnection() -> BankConnection {
        let status = mapStatus(status)
        let canSync = status == .active
        return BankConnection(
            id: id.stringValue,
            institutionName: institutionName ?? "Linked Institution",
            institutionId: institutionId ?? "",
            status: status,
            lastSyncedAt: lastSyncedAt,
            canSync: canSync,
            requiresConsent: status == .consentRequired,
            requiresMFA: status == .mfaRequired
        )
    }

    private func mapStatus(_ value: String?) -> BankConnectionStatus {
        switch value?.lowercased() {
        case "active":
            return .active
        case "syncing":
            return .syncing
        case "consent_required":
            return .consentRequired
        case "mfa_required":
            return .mfaRequired
        default:
            return .error
        }
    }
}

private struct BankAccountResponse: Decodable {
    let id: FlexibleIdentifier
    let connection: FlexibleIdentifier?
    let name: String?
    let accountType: String?
    let mask: String?
    let currentBalance: Double?
    let currencyCode: String?

    func toBankAccount() -> BankAccount {
        BankAccount(
            id: id.stringValue,
            connectionId: connection?.stringValue ?? "",
            name: name ?? "Account",
            type: accountType ?? "depository",
            mask: mask ?? "****",
            balance: currentBalance ?? 0,
            currency: currencyCode ?? "USD"
        )
    }
}

private struct BankTransactionResponse: Decodable {
    let id: FlexibleIdentifier
    let connection: FlexibleIdentifier?
    let account: FlexibleIdentifier?
    let merchantName: String?
    let description: String?
    let effectiveCategory: String?
    let amount: Double?
    let isoCurrencyCode: String?
    let direction: String?
    let date: String?
    let valueScore: Int?
    let removed: Bool?

    func toBankTransaction() -> BankTransaction {
        BankTransaction(
            id: id.stringValue,
            connectionId: connection?.stringValue ?? "",
            accountId: account?.stringValue ?? "",
            merchant: merchantName ?? description ?? "Bank Transaction",
            description: description ?? merchantName ?? "",
            category: effectiveCategory ?? "other",
            amount: amount ?? 0,
            currency: isoCurrencyCode ?? "USD",
            direction: TransactionType(rawValue: direction ?? "spend") ?? .spend,
            date: date ?? "",
            valueScore: valueScore,
            removed: removed ?? false
        )
    }
}

private struct BankFeedbackPatchRequest: Encodable {
    let satisfaction: Int?
    let regretScore: Int?
    let repurchaseLikelihood: Int?
    let usageFrequency: String?
    let reflection: String?

    static func from(_ feedback: TransactionFeedback) -> BankFeedbackPatchRequest {
        BankFeedbackPatchRequest(
            satisfaction: feedback.satisfaction,
            regretScore: feedback.regretScore,
            repurchaseLikelihood: feedback.repurchaseLikelihood,
            usageFrequency: feedback.usageFrequency,
            reflection: feedback.reflection
        )
    }
}
