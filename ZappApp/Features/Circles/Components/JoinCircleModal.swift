import SwiftUI

struct JoinCircleModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var inviteCode = ""
    var onJoin: (String) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Join Circle")
                    AppInput(title: "Invite code", value: $inviteCode)
                    AppButton(title: "Join") {
                        onJoin(inviteCode)
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
