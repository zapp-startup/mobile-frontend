import Foundation

@MainActor
final class MfaSetupViewModel: ObservableObject {
    @Published var otpauthURL = ""
    @Published var factorID = ""
    @Published var code = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didVerify = false

    private let authService: AuthService

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }

    func loadSetup() async {
        guard otpauthURL.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await authService.enrollMFA(friendlyName: "iOS Authenticator")
            factorID = response.factorId ?? ""
            otpauthURL = response.otpauthUrl ?? response.qrCode ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func verify(onSuccess: @escaping () -> Void) async {
        errorMessage = nil
        guard !factorID.isEmpty else {
            errorMessage = "Could not initialize MFA setup."
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await authService.verifyEnrollment(factorId: factorID, code: code)
            guard response.verified != false else {
                errorMessage = "Could not verify MFA code."
                return
            }
            didVerify = true
            onSuccess()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
