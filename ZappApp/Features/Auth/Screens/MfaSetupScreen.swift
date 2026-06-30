import SwiftUI

struct MfaSetupScreen: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = MfaSetupViewModel()
    var onContinue: () -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Set up MFA", subtitle: "Secure your account before proceeding.")
                    AuthCard(title: "Authenticator setup", subtitle: "Use your authenticator app with this setup URI.") {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            if viewModel.isLoading && viewModel.otpauthURL.isEmpty {
                                ProgressView().tint(AppColors.accent)
                            } else {
                                Text(viewModel.otpauthURL.isEmpty ? "Setup URL unavailable" : viewModel.otpauthURL)
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                                    .textSelection(.enabled)
                            }
                            MfaCodeField(code: $viewModel.code)
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                            }
                            if viewModel.didVerify {
                                Text("MFA setup confirmed. Continuing.")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.success)
                            }
                            AppButton(title: "Confirm and Continue", isLoading: viewModel.isLoading) {
                                Task { await viewModel.verify(onSuccess: onContinue) }
                            }
                        }
                    }
                    Button("Sign out and switch account") {
                        appState.logout()
                    }
                    .foregroundStyle(AppColors.warning)
                }
                .task { await viewModel.loadSetup() }
            }
        }
    }
}
