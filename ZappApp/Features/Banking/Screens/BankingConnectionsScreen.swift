import SwiftUI

struct BankingConnectionsScreen: View {
    @StateObject private var viewModel = BankingConnectionsViewModel()

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(
                    title: "Bank Connections",
                    subtitle: "Securely link institutions and sync accounts."
                )
                SyncStatusBanner(message: viewModel.syncStatusMessage ?? "Bank data is encrypted and consent-gated.")
                if let linkToken = viewModel.linkToken {
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Link token ready").font(AppTypography.cardTitle)
                            Text(linkToken).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                            AppInput(title: "Plaid public token", value: $viewModel.pendingPublicToken)
                            AppButton(title: "Finalize Link") {
                                Task { await viewModel.submitPublicToken() }
                            }
                        }
                    }
                }
                if viewModel.isLoading {
                    AppLoadingState(title: "Loading connections", message: "Fetching linked institutions.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Banking Error", message: errorMessage) { Task { await viewModel.load() } }
                } else if viewModel.connections.isEmpty {
                    BankingEmptyState {
                        Task { await viewModel.connectBank() }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.connections) { connection in
                                NavigationLink(value: TransactionsRoute.bankConnectionDetail(connection.id)) {
                                    BankConnectionCard(
                                        connection: connection,
                                        onTap: {},
                                        onSync: { Task { await viewModel.sync(connection: connection) } }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            AppButton(title: "Connect Another Bank") {
                                Task { await viewModel.connectBank() }
                            }
                        }
                    }
                }
                Spacer()
            }
            .task { await viewModel.load() }
            .sheet(isPresented: $viewModel.showConsentModal) {
                BankConsentModal { Task { await viewModel.submitConsent() } }
            }
            .sheet(isPresented: $viewModel.showMFAModal) {
                BankMfaModal { code in
                    Task { await viewModel.verifyMFA(code: code) }
                }
            }
        }
    }
}
