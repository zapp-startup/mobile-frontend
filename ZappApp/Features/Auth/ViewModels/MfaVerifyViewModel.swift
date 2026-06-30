import Foundation

@MainActor
final class MfaVerifyViewModel: ObservableObject {
    @Published var factors: [MFAFactor] = []
    @Published var selectedFactor: MFAFactor?
    @Published var code = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSucceed = false

    private let authService: AuthService

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }

    func loadFactors() async {
        guard factors.isEmpty else { return }
        do {
            let snapshot = try await authService.mfaSnapshot()
            factors = snapshot.factors
            selectedFactor = factors.first
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func verify(onSuccess: @escaping (AuthStateResponse) -> Void) async {
        errorMessage = nil
        guard let selectedFactor else {
            errorMessage = "Select an MFA factor."
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let challenge = try await authService.createMFAChallenge(factorId: selectedFactor.id)
            let session = try await authService.verifyMFAChallenge(
                factorId: selectedFactor.id,
                challengeId: challenge.challengeId,
                code: code
            )
            didSucceed = true
            onSuccess(session)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
