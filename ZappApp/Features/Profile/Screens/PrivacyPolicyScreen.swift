import SwiftUI

struct PrivacyPolicyScreen: View {
    @StateObject private var viewModel = PrivacyPolicyViewModel()

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    AppHeader(title: "Privacy Policy")
                    if viewModel.isLoading && viewModel.metadata == nil {
                        AppLoadingState(title: "Loading privacy metadata", message: "Fetching policy metadata from backend.")
                    } else if let errorMessage = viewModel.errorMessage, viewModel.metadata == nil {
                        AppErrorState(title: "Privacy metadata error", message: errorMessage) {
                            Task { await viewModel.load() }
                        }
                    } else {
                        AppCard {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Version: \(viewModel.metadata?.policyVersion ?? "Unavailable")").font(AppTypography.helper)
                                Text("Effective date: \(viewModel.metadata?.effectiveDate ?? "Unavailable")").font(AppTypography.helper)
                                Text("Last updated: \(viewModel.metadata?.lastUpdated ?? "Unavailable")")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                                if let policyURL = viewModel.metadata?.policyURL, !policyURL.isEmpty {
                                    Text("Policy URL: \(policyURL)")
                                        .font(AppTypography.caption)
                                        .foregroundStyle(AppColors.accent)
                                }
                            }
                        }
                        policySection(
                            title: "Data Collection",
                            body: "Zapp collects account, transaction, and profile data required to deliver budgeting, valuation, and assistant experiences."
                        )
                        policySection(
                            title: "Usage and Consent",
                            body: "Bank and third-party integrations remain consent-gated. You can revoke linked access from relevant settings surfaces."
                        )
                        policySection(
                            title: "Security",
                            body: "Session handling, MFA, and encrypted transmission are used to protect user data across supported platforms."
                        )
                    }
                }
            }
            .task { await viewModel.load() }
        }
    }

    private func policySection(title: String, body: String) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(title).font(AppTypography.sectionTitle)
                Text(body).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

@MainActor
private final class PrivacyPolicyViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var metadata: PrivacyPolicyMetadata?

    private let profileService = ProfileService()

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            metadata = try await profileService.fetchPrivacyPolicyMetadata()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
