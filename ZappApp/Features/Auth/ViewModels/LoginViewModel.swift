import Foundation
import AuthenticationServices
import UIKit

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var socialErrorMessage: String?
    @Published var didSucceed = false

    private let authService: AuthService
    private let webAuthenticator = OAuthWebAuthenticator()
    private var isGoogleAuthInProgress = false

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }

    func signIn(onSuccess: @escaping (AuthStateResponse) -> Void) async {
        errorMessage = nil
        didSucceed = false
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.isEmpty else {
            errorMessage = "Enter your email and password."; return
        }
        isLoading = true
        defer { isLoading = false }

        do {
            let state = try await authService.login(email: email.trimmingCharacters(in: .whitespaces), password: password)
            didSucceed = true
            onSuccess(state)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signInWithGoogle(
        onOAuthCallback: @escaping (URL) -> Void
    ) async {
        guard !isGoogleAuthInProgress else {
            #if DEBUG
            print("[OAuth Debug] Ignoring duplicate Google sign-in tap while auth is in progress.")
            #endif
            return
        }
        isGoogleAuthInProgress = true
        socialErrorMessage = nil
        isLoading = true
        defer {
            isLoading = false
            isGoogleAuthInProgress = false
        }

        do {
            let redirectAfter = "zapp://auth/callback"
            let authorizeURL = try authService.googleOAuthBrowserStartURL(redirectURIAfter: redirectAfter)
            #if DEBUG
            print("[OAuth Debug] Launching ASWebAuthenticationSession URL: \(authorizeURL.absoluteString)")
            #endif
            guard let callbackURL = try await webAuthenticator.authenticate(
                authorizeURL: authorizeURL,
                callbackScheme: "zapp"
            ) else {
                socialErrorMessage = "Google sign-in was cancelled."
                return
            }
            #if DEBUG
            print("[OAuth Debug] ASWebAuthenticationSession callback URL: \(callbackURL.absoluteString)")
            #endif
            onOAuthCallback(callbackURL)
        } catch {
            #if DEBUG
            print("[OAuth Debug] signInWithGoogle error: \(error.localizedDescription)")
            #endif
            socialErrorMessage = error.localizedDescription
        }
    }
}

private final class OAuthWebAuthenticator: NSObject, ASWebAuthenticationPresentationContextProviding {
    private var session: ASWebAuthenticationSession?

    func authenticate(authorizeURL: URL, callbackScheme: String) async throws -> URL? {
        try await withCheckedThrowingContinuation { continuation in
            if session != nil {
                continuation.resume(throwing: APIError.server(statusCode: 400, message: "OAuth session is already active."))
                return
            }
            let session = ASWebAuthenticationSession(
                url: authorizeURL,
                callbackURLScheme: callbackScheme
            ) { callbackURL, error in
                defer { self.session = nil }
                if let error {
                    #if DEBUG
                    print("[OAuth Debug] ASWebAuthenticationSession completion error: \(error.localizedDescription)")
                    #endif
                    if (error as NSError).code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                        continuation.resume(returning: nil)
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                #if DEBUG
                print("[OAuth Debug] ASWebAuthenticationSession completion success, callback present: \(callbackURL != nil)")
                #endif
                continuation.resume(returning: callbackURL)
            }
            session.prefersEphemeralWebBrowserSession = true
            session.presentationContextProvider = self
            self.session = session
            _ = session.start()
        }
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            return window
        }
        return ASPresentationAnchor()
    }
}
