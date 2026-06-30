import SwiftUI

struct MfaEnrollmentCard: View {
    var isEnabled: Bool
    var onEnroll: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("MFA Enrollment").font(AppTypography.sectionTitle)
                Text(isEnabled ? "MFA is enabled." : "Enroll MFA to strengthen account security.")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)
                if !isEnabled {
                    AppButton(title: "Enroll MFA", action: onEnroll)
                }
            }
        }
    }
}
