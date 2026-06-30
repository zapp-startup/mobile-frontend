import SwiftUI

struct TransactionMetricRow: View {
    let totalCount: Int
    let totalSpent: Double
    let totalIncome: Double
    let net: Double

    var body: some View {
        AppCard {
            HStack {
                metric(title: "Count", value: "\(totalCount)")
                metric(title: "Spent", value: currency(totalSpent))
                metric(title: "Income", value: currency(totalIncome))
                metric(title: "Net", value: currency(net))
            }
        }
    }

    @ViewBuilder
    private func metric(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
            Text(value).font(AppTypography.helper)
        }
        if title != "Net" { Spacer() }
    }

    private func currency(_ amount: Double) -> String {
        Formatters.currency.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}
