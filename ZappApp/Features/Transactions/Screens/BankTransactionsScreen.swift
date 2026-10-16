import SwiftUI

struct BankTransactionsScreen: View {
    @StateObject private var viewModel = BankConnectionDetailViewModel()
    let connectionId: String?

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Bank Transactions")
                if connectionId != nil {
                    if viewModel.isLoading {
                        AppLoadingState(title: "Loading bank transactions", message: "Syncing linked activity.")
                    } else if let errorMessage = viewModel.errorMessage {
                        AppErrorState(title: "Bank Transaction Error", message: errorMessage, retry: nil)
                    } else if let transactions = viewModel.payload?.transactions, !transactions.isEmpty {
                        ScrollView {
                            VStack(spacing: AppSpacing.sm) {
                                ForEach(transactions) { transaction in
                                    BankTransactionRow(transaction: transaction)
                                }
                            }
                        }
                    } else {
                        AppEmptyState(title: "No bank transactions", message: "Synced bank transactions will appear here.")
                    }
                } else {
                    AppErrorState(title: "No connection selected", message: "Select a bank connection first.", retry: nil)
                }
                Spacer()
            }
            .task {
                if let connectionId {
                    await viewModel.load(connectionId: connectionId)
                }
            }
        }
    }
}
