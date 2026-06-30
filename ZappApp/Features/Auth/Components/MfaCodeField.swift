import SwiftUI

struct MfaCodeField: View {
    @Binding var code: String
    var label = "Verification code"

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
            TextField("123456", text: $code)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(AppSpacing.md)
                .background(AppColors.subtle)
                .cornerRadius(AppRadii.md)
                .onChange(of: code) { _, newValue in
                    code = String(newValue.filter { $0.isNumber }.prefix(6))
                }
        }
    }
}
