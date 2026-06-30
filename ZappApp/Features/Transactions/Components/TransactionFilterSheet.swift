import SwiftUI

struct TransactionFilterSheet: View {
    @Binding var filter: TransactionFilter
    let categories: [String]
    var onApply: () -> Void
    var onClear: () -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Filters", subtitle: "Refine by category, type, and date")
                    Picker("Category", selection: $filter.category) {
                        Text("All").tag("")
                        ForEach(categories, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)

                    Picker("Type", selection: Binding(
                        get: { filter.type ?? .expense },
                        set: { filter.type = $0 }
                    )) {
                        ForEach(TransactionType.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    AppInput(title: "Date from (YYYY-MM-DD)", value: $filter.dateFrom)
                    AppInput(title: "Date to (YYYY-MM-DD)", value: $filter.dateTo)
                    AppButton(title: "Apply Filters", action: onApply)
                    Button("Clear Filters", action: onClear).foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
