import SwiftUI

struct BankTransactionRow: View {
    let transaction: BankTransaction

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(transaction.merchant).font(AppTypography.cardTitle)
                Text("\(transaction.category) • \(transaction.date)")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(Formatters.currency.string(from: NSNumber(value: transaction.amount)) ?? "$0.00")
                if let score = transaction.valueScore {
                    Text("V\(score)").font(AppTypography.caption).foregroundStyle(AppColors.accent)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }
}
