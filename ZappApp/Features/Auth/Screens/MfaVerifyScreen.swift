import SwiftUI

struct MfaVerifyScreen: View {
    @StateObject private var viewModel = MfaVerifyViewModel()
    var onSuccess: (AuthStateResponse) -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Verify MFA", subtitle: "Choose your factor and continue.")
                    AuthCard(title: "Verification", subtitle: "Enter the current code from your authenticator app.") {
                        VStack(spacing: AppSpacing.md) {
                            AppSelect(title: "Factor", value: viewModel.selectedFactor?.displayName ?? "Select factor")
                            if !viewModel.factors.isEmpty {
                                Picker("Factor", selection: Binding(
                                    get: { viewModel.selectedFactor?.id ?? viewModel.factors.first?.id ?? "" },
                                    set: { newValue in
                                        viewModel.selectedFactor = viewModel.factors.first(where: { $0.id == newValue })
                                    }
                                )) {
                                    ForEach(viewModel.factors, id: \.self) { factor in
                                        Text(factor.displayName).tag(factor.id)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            MfaCodeField(code: $viewModel.code)
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                            }
                            if viewModel.didSucceed {
                                Text("Verification successful. Routing...")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.success)
                            }
                            AppButton(title: "Verify and Continue", isLoading: viewModel.isLoading) {
                                Task { await viewModel.verify(onSuccess: onSuccess) }
                            }
                        }
                    }
                }
                .task { await viewModel.loadFactors() }
            }
        }
    }
}
