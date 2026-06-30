import SwiftUI

struct TransactionFormScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var formViewModel = TransactionFormViewModel()
    @StateObject private var transactionsViewModel = TransactionsViewModel()
    let transactionId: String?

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: transactionId == nil ? "Add Transaction" : "Edit Transaction")
                    AppInput(title: "Description", value: $formViewModel.description)
                    AppInput(title: "Merchant", value: $formViewModel.merchant)
                    AppInput(title: "Amount", value: $formViewModel.amount)
                    AppInput(title: "Category", value: $formViewModel.category)
                    Picker("Type", selection: $formViewModel.type) {
                        ForEach(TransactionType.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    AppInput(title: "Date (YYYY-MM-DD)", value: $formViewModel.date)
                    AppInput(title: "Satisfaction (optional)", value: $formViewModel.satisfaction)
                    if let errorMessage = formViewModel.errorMessage {
                        Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                    }
                    AppButton(title: "Save Transaction") {
                        guard let tx = formViewModel.build(existingId: transactionId) else { return }
                        Task {
                            await transactionsViewModel.save(transaction: tx)
                            dismiss()
                        }
                    }
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    if let transactionId {
                        Button("Delete") {
                            Task {
                                await transactionsViewModel.delete(transactionId: transactionId)
                                dismiss()
                            }
                        }
                        .foregroundStyle(AppColors.error)
                    }
                }
                .task {
                    await transactionsViewModel.load()
                    let existing = transactionsViewModel.transactions.first(where: { $0.id == transactionId })
                    formViewModel.load(existing: existing)
                }
            }
        }
    }
}
