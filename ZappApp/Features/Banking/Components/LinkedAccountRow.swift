import SwiftUI

struct LinkedAccountRow: View {
    let account: BankAccount

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(account.name).font(AppTypography.cardTitle)
                Text("\(account.type.capitalized) • ••••\(account.mask)")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            Text(Formatters.currency.string(from: NSNumber(value: account.balance)) ?? "$0.00")
                .font(AppTypography.helper)
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }
}
