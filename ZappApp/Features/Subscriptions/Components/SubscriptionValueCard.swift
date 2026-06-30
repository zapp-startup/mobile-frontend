import SwiftUI

struct SubscriptionValueCard: View {
    let valueScore: Int
    let confidence: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Value Score").font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                Text("\(valueScore)/100").font(AppTypography.cardTitle)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Confidence").font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                Text("\(Int(confidence * 100))%").font(AppTypography.cardTitle)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }
}
