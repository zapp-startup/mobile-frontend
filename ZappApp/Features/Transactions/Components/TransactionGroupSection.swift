import SwiftUI

struct TransactionGroupSection: View {
    let date: String
    let transactions: [Transaction]
    var onTapTransaction: (Transaction) -> Void
    var onTapFeedback: (Transaction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(date).font(AppTypography.sectionTitle)
            ForEach(transactions) { tx in
                TransactionRow(
                    transaction: tx,
                    onTap: { onTapTransaction(tx) },
                    onFeedback: { onTapFeedback(tx) }
                )
            }
        }
    }
}
