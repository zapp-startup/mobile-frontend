import SwiftUI

struct SubscriptionDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var listViewModel = SubscriptionsViewModel()
    @StateObject private var detailViewModel = SubscriptionDetailViewModel()
    let subscriptionId: UUID

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Subscription Detail")
                if let errorMessage = detailViewModel.errorMessage {
                    AppErrorState(title: "Subscription missing", message: errorMessage, retry: nil)
                } else if let subscription = detailViewModel.subscription {
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(subscription.merchant).font(AppTypography.sectionTitle)
                            Text("Amount: \(Formatters.currency.string(from: NSNumber(value: subscription.amount)) ?? "$0.00")")
                            Text("Cycle: \(subscription.billingCycle.rawValue.capitalized)")
                            Text("Status: \(subscription.status.rawValue.capitalized)")
                            Text("Started: \(subscription.startedAt)")
                            if let notes = subscription.notes, !notes.isEmpty {
                                Text("Notes: \(notes)")
                                    .font(AppTypography.helper)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                    SubscriptionValuationSection(valuation: subscription.valuation)
                    NavigationLink(value: SubscriptionsRoute.subscriptionForm(subscription.id)) {
                        Text("Edit Subscription")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                            .background(AppColors.subtle)
                            .cornerRadius(AppRadii.md)
                    }
                    .buttonStyle(.plain)
                    Button("Delete Subscription") {
                        Task {
                            await listViewModel.delete(id: subscription.id)
                            dismiss()
                        }
                    }
                    .foregroundStyle(AppColors.error)
                } else {
                    AppLoadingState(title: "Loading subscription", message: "Fetching subscription details.")
                }
                Spacer()
            }
            .task {
                await listViewModel.load()
                detailViewModel.bind(subscriptionId: subscriptionId, source: listViewModel.subscriptions)
            }
        }
    }
}
