import SwiftUI

struct SubscriptionFormScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var formViewModel = SubscriptionFormViewModel()
    @StateObject private var listViewModel = SubscriptionsViewModel()
    let subscriptionId: UUID?

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: subscriptionId == nil ? "Add Subscription" : "Edit Subscription")
                    AppInput(title: "Merchant", value: $formViewModel.merchant)
                    AppInput(title: "Amount", value: $formViewModel.amount, keyboardType: .decimalPad)
                    Picker("Billing Cycle", selection: $formViewModel.cycle) {
                        ForEach(BillingCycle.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    AppInput(title: "Start date (YYYY-MM-DD)", value: $formViewModel.startDate)
                    AppTextarea(title: "Notes", value: $formViewModel.notes)
                    if let errorMessage = formViewModel.errorMessage {
                        Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                    }
                    AppButton(title: "Save Subscription") {
                        guard let built = formViewModel.build(existingId: subscriptionId) else { return }
                        Task {
                            await listViewModel.save(built)
                            dismiss()
                        }
                    }
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    if let subscriptionId {
                        Button("Delete") {
                            Task {
                                await listViewModel.delete(id: subscriptionId)
                                dismiss()
                            }
                        }
                        .foregroundStyle(AppColors.error)
                    }
                }
                .task {
                    await listViewModel.load()
                    formViewModel.load(existing: listViewModel.subscriptions.first(where: { $0.id == subscriptionId }))
                }
            }
        }
    }
}
