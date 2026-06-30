import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = LoginViewModel()
    var onSignUp: () -> Void
    var onLogin: (AuthStateResponse) -> Void
    var onOAuthCallback: (URL) -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Zapp", subtitle: "Premium personal finance intelligence")
                    AuthCard(title: "Welcome back", subtitle: "Enter your credentials to continue.") {
                        VStack(spacing: AppSpacing.md) {
                            SocialAuthButton(title: "Continue with Google", isLoading: viewModel.isLoading) {
                                Task { await viewModel.signInWithGoogle(onOAuthCallback: onOAuthCallback) }
                            }
                            AppInput(title: "Email", value: $viewModel.email)
                            AppInput(title: "Password", value: $viewModel.password, secure: true)
                            if let socialErrorMessage = viewModel.socialErrorMessage {
                                Text(socialErrorMessage).font(AppTypography.caption).foregroundStyle(AppColors.warning)
                            }
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                            }
                            if viewModel.didSucceed {
                                Text("Signed in successfully. Routing to next secure step.")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.success)
                            }
                            AppButton(title: "Sign In", isLoading: viewModel.isLoading) {
                                Task { await viewModel.signIn(onSuccess: onLogin) }
                            }
                        }
                    }
                    HStack(spacing: AppSpacing.xs) {
                        Text("Need an account?").foregroundStyle(AppColors.textSecondary)
                        Button("Sign up", action: onSignUp).foregroundStyle(AppColors.accent)
                    }
                    Text("By continuing you agree to privacy and legal terms.")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}
