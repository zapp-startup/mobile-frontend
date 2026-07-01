import SwiftUI

struct CreateTargetModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var amount = ""
    var onCreate: (String, Double) -> Void

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var parsedAmount: Double? {
        Double(amount.trimmingCharacters(in: .whitespaces))
    }

    private var isValid: Bool {
        !trimmedTitle.isEmpty && (parsedAmount ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Create Target")
                    AppInput(title: "Target name", value: $title)
                    AppInput(title: "Target amount (USD)", value: $amount, keyboardType: .decimalPad)
                    AppButton(title: "Create") {
                        if let value = parsedAmount {
                            onCreate(trimmedTitle, value)
                            dismiss()
                        }
                    }
                    .disabled(!isValid)
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
