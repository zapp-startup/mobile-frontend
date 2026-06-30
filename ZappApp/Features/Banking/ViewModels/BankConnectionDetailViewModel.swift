import Foundation

@MainActor
final class BankConnectionDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var payload: BankConnectionDetailPayload?

    private let service: BankingService

    init(service: BankingService = BankingService()) {
        self.service = service
    }

    func load(connectionId: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let connections = try await service.fetchConnections()
            let accounts = try await service.fetchAccounts()
            let transactions = try await service.fetchTransactions()
            guard let connection = connections.first(where: { $0.id == connectionId }) else {
                throw APIError.server(statusCode: 404, message: "Bank connection not found.")
            }
            payload = BankConnectionDetailPayload(
                connection: connection,
                accounts: accounts.filter { $0.connectionId == connectionId },
                transactions: transactions.filter { $0.connectionId == connectionId }
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
