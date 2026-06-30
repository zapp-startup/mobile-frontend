import SwiftUI

struct MetricDrilldownCard: View {
    let title: String
    let values: [String: Double]

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(title).font(AppTypography.sectionTitle)
                if values.isEmpty {
                    Text("No values available").font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                } else {
                    ForEach(values.keys.sorted(), id: \.self) { key in
                        HStack {
                            Text(key).font(AppTypography.helper)
                            Spacer()
                            Text(String(format: "%.2f", values[key] ?? 0)).foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
            }
        }
    }
}
