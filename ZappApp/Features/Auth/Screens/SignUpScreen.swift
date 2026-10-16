import SwiftUI

struct SignUpScreen: View {
    @StateObject private var viewModel = SignUpViewModel()
    var onSignIn: () -> Void
    var onComplete: (AuthStateResponse) -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Zapp", subtitle: "Create your account")
                    AuthCard(title: "Create your account", subtitle: "Set up secure credentials to continue.") {
                        VStack(spacing: AppSpacing.md) {
                            AppInput(title: "Full name", value: $viewModel.fullName, textContentType: .name)
                            AppInput(title: "Email", value: $viewModel.email, keyboardType: .emailAddress, autocapitalization: .never, disableAutocorrection: true, textContentType: .emailAddress)
                            AppInput(title: "Password", value: $viewModel.password, secure: true)
                            AppInput(title: "Confirm password", value: $viewModel.confirmPassword, secure: true)
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                            }
                            if let successMessage = viewModel.successMessage {
                                Text(successMessage).font(AppTypography.caption).foregroundStyle(AppColors.success)
                            }
                            AppButton(title: "Sign Up", isLoading: viewModel.isLoading) {
                                Task { await viewModel.signUp(onSuccess: onComplete) }
                            }
                        }
                    }
                    HStack(spacing: AppSpacing.xs) {
                        Text("Already have an account?").foregroundStyle(AppColors.textSecondary)
                        Button("Sign in", action: onSignIn).foregroundStyle(AppColors.accent)
                    }
                    Text("By creating an account you agree to privacy and legal terms.")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}
