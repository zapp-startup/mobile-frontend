import SwiftUI

struct TransactionsScreen: View {
    @StateObject private var viewModel = TransactionsViewModel()
    var onNavigate: (TransactionsRoute) -> Void

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(
                    title: "Transactions",
                    trailing: AnyView(Button {
                        onNavigate(.transactionForm(nil))
                    } label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(AppColors.accent)
                    })
                )

                TransactionSearchBar(query: $viewModel.searchText)
                TransactionMetricRow(
                    totalCount: viewModel.filtered.count,
                    totalSpent: viewModel.totalSpent,
                    totalIncome: viewModel.totalIncome,
                    net: viewModel.net
                )
                HStack {
                    AppButton(title: "Filters") { viewModel.showFilter = true }
                    AppButton(title: "Banking") { onNavigate(.bankingConnections) }
                }

                SpendingCalendarCard(totalSpent: viewModel.totalSpent)

                if viewModel.isLoading {
                    AppLoadingState(title: "Loading transactions", message: "Fetching activity...")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Transaction Error", message: errorMessage) {
                        Task { await viewModel.load() }
                    }
                } else if viewModel.grouped.isEmpty {
                    AppEmptyState(title: "No transactions", message: "Add your first transaction to get started.")
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppSpacing.lg) {
                            if let successMessage = viewModel.successMessage {
                                StatusChip(text: successMessage, tone: AppColors.success)
                            }
                            ForEach(viewModel.grouped, id: \.0) { group in
                                TransactionGroupSection(
                                    date: group.0,
                                    transactions: group.1,
                                    onTapTransaction: { tx in onNavigate(.transactionDetail(tx.id)) },
                                    onTapFeedback: { tx in
                                        viewModel.selectedTransaction = tx
                                        viewModel.showFeedbackSheet = true
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .task { await viewModel.load() }
            .sheet(isPresented: $viewModel.showFilter) {
                TransactionFilterSheet(
                    filter: $viewModel.filter,
                    categories: viewModel.categories,
                    onApply: { viewModel.showFilter = false },
                    onClear: {
                        viewModel.filter = TransactionFilter()
                        viewModel.showFilter = false
                    }
                )
            }
            .sheet(isPresented: $viewModel.showFeedbackSheet) {
                TransactionFeedbackSheet { feedback in
                    Task { await viewModel.submitFeedback(feedback) }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsScreen(onNavigate: { _ in })
    }
}
