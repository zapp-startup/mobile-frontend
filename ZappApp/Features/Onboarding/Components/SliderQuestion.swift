import SwiftUI

struct SliderQuestion: View {
    let title: String
    @Binding var value: Double
    var range: ClosedRange<Double> = 1...10

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
            Slider(value: $value, in: range, step: 1)
                .tint(AppColors.accent)
            Text("Selected: \(Int(value))/\(Int(range.upperBound))").font(AppTypography.cardTitle)
        }
    }
}
