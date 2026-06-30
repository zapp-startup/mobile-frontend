import SwiftUI

struct FinancialProfileCard: View {
    @Binding var profile: FinancialProfile
    var onSave: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Financial Profile").font(AppTypography.sectionTitle)
                AppInput(title: "Life stage", value: $profile.lifeStage)
                AppInput(title: "Income range", value: $profile.incomeRange)
                AppInput(title: "Monthly fixed expenses", value: Binding(
                    get: { String(profile.monthlyFixedExpenses) },
                    set: { profile.monthlyFixedExpenses = Double($0) ?? profile.monthlyFixedExpenses }
                ))
                AppButton(title: "Save Profile", action: onSave)
            }
        }
    }
}
