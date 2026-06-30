import SwiftUI

struct ValuationInputCard: View {
    @Binding var description: String
    @Binding var amount: String
    var onCompute: () -> Void
    var isLoading: Bool

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Valuation Input").font(AppTypography.sectionTitle)
                AppInput(title: "Description", value: $description)
                AppInput(title: "Amount", value: $amount)
                AppButton(title: "Compute Valuation", isLoading: isLoading, action: onCompute)
            }
        }
    }
}
