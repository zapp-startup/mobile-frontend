import SwiftUI

struct RecentTransactionCard: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(transaction.description).font(AppTypography.cardTitle)
                Text(transaction.category).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text(amountText).font(AppTypography.cardTitle)
                Text(transaction.date).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }

    private var amountText: String {
        let amount = Formatters.currency.string(from: NSNumber(value: transaction.amount)) ?? "$0.00"
        return transaction.type == .expense ? "-\(amount)" : amount
    }
}
