import SwiftUI

struct CreateCircleModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var isPrivate = true
    var onCreate: (String, Bool) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Create Circle")
                    AppInput(title: "Circle name", value: $name)
                    Toggle("Private circle", isOn: $isPrivate)
                    AppButton(title: "Create") {
                        onCreate(name, isPrivate)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
