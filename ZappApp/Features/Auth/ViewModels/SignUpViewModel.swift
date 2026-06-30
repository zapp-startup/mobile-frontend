import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let authService: AuthService

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }

    func signUp(onSuccess: @escaping (AuthStateResponse) -> Void) async {
        errorMessage = nil
        successMessage = nil
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        defer { isLoading = false }
        do {
            let state = try await authService.signUp(fullName: fullName, email: email, password: password)
            successMessage = "Account created. Continue to secure MFA setup."
            onSuccess(state)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
