import Foundation

@MainActor
final class BankingConnectionsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var connections: [BankConnection] = []
    @Published var showConsentModal = false
    @Published var showMFAModal = false
    @Published var selectedConnection: BankConnection?
    @Published var syncStatusMessage: String?
    @Published var linkToken: String?
    @Published var pendingPublicToken = ""

    private let service: BankingService
    private let bankLinkCoordinator: BankLinkCoordinator

    init(
        service: BankingService = BankingService(),
        bankLinkCoordinator: BankLinkCoordinator = BankLinkCoordinator()
    ) {
        self.service = service
        self.bankLinkCoordinator = bankLinkCoordinator
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            connections = try await service.fetchConnections()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func connectBank() async {
        do {
            showConsentModal = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitConsent() async {
        do {
            linkToken = try await bankLinkCoordinator.prepareSecureLinking(
                consentText: "I consent to securely share financial account and transaction data with Zapp."
            )
            showConsentModal = false
            syncStatusMessage = "Link token created. Complete bank authentication to continue."
        } catch {
            errorMessage = error.localizedDescription
            if case APIError.server(_, _, let code) = error, code == "mfa_required" {
                showMFAModal = true
            }
        }
    }

    func verifyMFA(code: String) async {
        do {
            let snapshot = try await AuthService().mfaSnapshot()
            guard let factorId = snapshot.factors.first?.id else {
                throw APIError.server(statusCode: 400, message: "No MFA factors found for this account.")
            }
            let challenge = try await AuthService().createMFAChallenge(factorId: factorId)
            _ = try await AuthService().verifyMFAChallenge(factorId: factorId, challengeId: challenge.challengeId, code: code)
            showMFAModal = false
            syncStatusMessage = "MFA verified. Continue bank linking."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitPublicToken() async {
        guard !pendingPublicToken.isEmpty else {
            errorMessage = "Paste a valid Plaid public token."
            return
        }
        do {
            let linked = try await bankLinkCoordinator.finalizeLink(publicToken: pendingPublicToken)
            replace(linked)
            pendingPublicToken = ""
            syncStatusMessage = "Bank linked successfully."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func sync(connection: BankConnection) async {
        do {
            try await service.syncConnection(connectionId: connection.id)
            syncStatusMessage = "Sync in progress for \(connection.institutionName)."
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func replace(_ updated: BankConnection) {
        if let index = connections.firstIndex(where: { $0.id == updated.id }) {
            connections[index] = updated
        } else {
            connections.append(updated)
        }
    }
}
