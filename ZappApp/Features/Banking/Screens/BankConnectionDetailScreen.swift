import SwiftUI

struct BankConnectionDetailScreen: View {
    @StateObject private var viewModel = BankConnectionDetailViewModel()
    let connectionId: String

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Connection Detail")
                if viewModel.isLoading {
                    AppLoadingState(title: "Loading connection", message: "Fetching accounts and transactions.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Could not load connection", message: errorMessage, retry: nil)
                } else if let payload = viewModel.payload {
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(payload.connection.institutionName).font(AppTypography.sectionTitle)
                            Text("Status: \(payload.connection.status.rawValue)")
                            Text("Last synced: \(payload.connection.lastSyncedAt ?? "Never")")
                        }
                    }
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            SectionHeader(title: "Linked Accounts")
                            ForEach(payload.accounts) { account in
                                LinkedAccountRow(account: account)
                            }
                        }
                    }
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            SectionHeader(title: "Recent Bank Transactions", actionTitle: "See all") {}
                            ForEach(payload.transactions.prefix(3)) { transaction in
                                BankTransactionRow(transaction: transaction)
                            }
                            NavigationLink(value: TransactionsRoute.bankTransactions(payload.connection.id)) {
                                Text("Open Full Bank Transactions")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, AppSpacing.md)
                                    .background(AppColors.subtle)
                                    .cornerRadius(AppRadii.md)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                Spacer()
            }
            .task { await viewModel.load(connectionId: connectionId) }
        }
    }
}
