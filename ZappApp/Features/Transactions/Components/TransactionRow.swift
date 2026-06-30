import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    var onTap: () -> Void
    var onFeedback: () -> Void

    var body: some View {
        HStack {
            SwiftUI.Circle()
                .fill(categoryTone.opacity(0.15))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: transaction.type.isExpense ? "arrow.down.right" : "arrow.up.right")
                        .foregroundStyle(categoryTone)
                )
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(transaction.description).font(AppTypography.cardTitle)
                Text("\(transaction.category) • \(transaction.merchant)")
                    .font(AppTypography.miniLabel)
                    .kerning(1)
                    .foregroundStyle(AppColors.textMuted)
                    .textCase(.uppercase)
                if let score = transaction.valueScore {
                    StatusChip(text: "Value \(score)", tone: AppColors.accentCyan)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text(amountText).font(AppTypography.cardTitle).foregroundStyle(amountTone)
                Text(transaction.date).font(AppTypography.caption).foregroundStyle(AppColors.textFaint)
                Button("Feedback", action: onFeedback)
                    .font(AppTypography.miniLabel)
                    .kerning(1)
                    .foregroundStyle(AppColors.accentCyan)
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.inset)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadii.lg)
                .stroke(AppColors.borderStrong.opacity(0.7), lineWidth: 1)
        )
        .cornerRadius(AppRadii.lg)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }

    private var amountText: String {
        let amount = Formatters.currency.string(from: NSNumber(value: transaction.amount)) ?? "$0.00"
        return transaction.type.isExpense ? "-\(amount)" : amount
    }

    private var amountTone: Color {
        transaction.type.isExpense ? AppColors.accentRed : AppColors.accentGreen
    }

    private var categoryTone: Color {
        switch transaction.category.lowercased() {
        case "food": return AppColors.accentYellow
        case "income": return AppColors.accentGreen
        default: return AppColors.accentCyan
        }
    }
}
