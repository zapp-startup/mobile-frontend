import SwiftUI

struct BankMfaModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var code = ""
    var onVerify: (String) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Bank MFA Verification", subtitle: "Enter your 6-digit bank MFA code.")
                    AppInput(title: "Code", value: $code)
                    AppButton(title: "Verify") {
                        onVerify(code)
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
