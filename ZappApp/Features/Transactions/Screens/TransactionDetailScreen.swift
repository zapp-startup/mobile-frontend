import SwiftUI

struct TransactionDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var detailViewModel = TransactionDetailViewModel()
    @StateObject private var transactionsViewModel = TransactionsViewModel()
    @State private var showFeedbackSheet = false

    let transactionId: String

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Transaction Detail")

                if let errorMessage = detailViewModel.errorMessage {
                    AppErrorState(title: "Missing transaction", message: errorMessage, retry: nil)
                } else if let transaction = detailViewModel.transaction {
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(transaction.description).font(AppTypography.sectionTitle)
                            Text("Amount: \(Formatters.currency.string(from: NSNumber(value: transaction.amount)) ?? "$0.00")")
                            Text("Category: \(transaction.category)")
                            Text("Type: \(transaction.type.legacyDisplayName.capitalized)")
                            Text("Date: \(transaction.date)")
                        }
                    }
                    ValueScoreBreakdownCard(valueScore: transaction.valueScore ?? 0, satisfaction: transaction.satisfaction)
                    if transaction.source != "bank" {
                        NavigationLink(value: TransactionsRoute.transactionForm(transaction.id)) {
                            Text("Edit Transaction")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.subtle)
                                .cornerRadius(AppRadii.md)
                        }
                    }
                    AppButton(title: "Give Feedback") { showFeedbackSheet = true }
                    if transaction.source != "bank" {
                        Button("Delete Transaction") {
                            Task {
                                await transactionsViewModel.delete(transactionId: transaction.id)
                                dismiss()
                            }
                        }
                        .foregroundStyle(AppColors.error)
                    }
                } else {
                    AppLoadingState(title: "Loading detail", message: "Finding transaction record...")
                }
                Spacer()
            }
            .task {
                await transactionsViewModel.load()
                detailViewModel.bind(transactionId: transactionId, source: transactionsViewModel.transactions)
            }
            .sheet(isPresented: $showFeedbackSheet) {
                TransactionFeedbackSheet { feedback in
                    Task {
                        transactionsViewModel.selectedTransaction = detailViewModel.transaction
                        await transactionsViewModel.submitFeedback(feedback)
                        detailViewModel.bind(transactionId: transactionId, source: transactionsViewModel.transactions)
                    }
                }
            }
        }
    }
}
