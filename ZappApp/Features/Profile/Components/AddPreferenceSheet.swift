import SwiftUI

struct AddPreferenceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var key = ""
    @State private var value = ""
    @State private var category = ""
    var onSave: (String, String, String) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Add Preference")
                    AppInput(title: "Key", value: $key)
                    AppInput(title: "Value", value: $value)
                    AppInput(title: "Category", value: $category)
                    AppButton(title: "Save") {
                        onSave(key, value, category)
                        dismiss()
                    }
                    .disabled(key.trimmingCharacters(in: .whitespaces).isEmpty || value.trimmingCharacters(in: .whitespaces).isEmpty)
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
