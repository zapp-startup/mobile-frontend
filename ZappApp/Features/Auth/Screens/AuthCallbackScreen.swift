import SwiftUI

struct AuthCallbackScreen: View {
    @EnvironmentObject private var appState: AppState
    @State private var didFinish = false
    @State private var errorMessage: String?
    private let authService = AuthService()

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                ProgressView().tint(AppColors.accent)
                Text("Signing you in...").font(AppTypography.sectionTitle)
                Text(didFinish ? "Callback complete. Redirecting." : "Completing secure callback processing.")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)
                if let errorMessage {
                    Text(errorMessage)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.error)
                }
            }
            .task {
                guard appState.oauthCallbackURL != nil else {
                    appState.currentAuthStep = .login
                    return
                }
                #if DEBUG
                print("[Auth Callback Debug] Incoming callback URL: \(appState.oauthCallbackURL?.absoluteString ?? "<missing>")")
                if let callbackURL = appState.oauthCallbackURL {
                    let cookies = HTTPCookieStorage.shared.cookies(for: callbackURL) ?? []
                    let cookieDump = cookies.isEmpty
                        ? "<no cookies for callback URL>"
                        : cookies.map { "\($0.name)=\($0.value) [domain=\($0.domain)]" }.joined(separator: "; ")
                    print("[Auth Callback Debug] Cookie snapshot at callback: \(cookieDump)")
                }
                #endif
                do {
                    let state = try await authService.bootstrapSession()
                    didFinish = true
                    appState.applyAuthState(state)
                    appState.oauthCallbackURL = nil
                } catch {
                    errorMessage = error.localizedDescription
                    appState.currentAuthStep = .login
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
