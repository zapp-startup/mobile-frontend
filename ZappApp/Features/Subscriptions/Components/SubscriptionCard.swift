import SwiftUI

struct SubscriptionCard: View {
    let subscription: Subscription
    var onTap: () -> Void
    var onEdit: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(subscription.merchant).font(AppTypography.sectionTitle)
                    Spacer()
                    StatusChip(text: subscription.status.rawValue.capitalized, tone: AppColors.success)
                }
                Text("\(amount) • \(subscription.billingCycle.rawValue.capitalized)")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)
                if let valuation = subscription.valuation {
                    SubscriptionValueCard(valueScore: valuation.valueScore, confidence: valuation.confidence)
                }
                HStack {
                    Text("Started \(subscription.startedAt)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textMuted)
                    Spacer()
                    Button("Edit", action: onEdit).foregroundStyle(AppColors.accentCyan)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: AppRadii.xl)
                .stroke(AppColors.accentBlue.opacity(0.20), lineWidth: 1)
        )
        .shadow(color: AppColors.accentBlue.opacity(0.18), radius: 10, x: 0, y: 0)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }

    private var amount: String {
        Formatters.currency.string(from: NSNumber(value: subscription.amount)) ?? "$0.00"
    }
}
