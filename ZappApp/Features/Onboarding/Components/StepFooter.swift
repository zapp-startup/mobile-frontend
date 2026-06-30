import SwiftUI

struct StepFooter: View {
    let isFirstStep: Bool
    let isLastStep: Bool
    let isLoading: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            if !isFirstStep {
                Button("Back", action: onBack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.subtle)
                    .cornerRadius(AppRadii.md)
            }
            AppButton(title: isLastStep ? "Complete" : "Continue", isLoading: isLoading, action: onNext)
        }
    }
}
