import SwiftUI

struct ReflectionDialog: View {
    @Environment(\.dismiss) private var dismiss
    @State private var regretScore = 2.0
    @State private var satisfaction = 70.0
    @State private var notes = ""
    var onSave: (TransactionFeedback) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Reflection")
                    SliderQuestion(title: "Regret score", value: $regretScore)
                    SliderQuestion(title: "Satisfaction", value: $satisfaction, range: 0...100)
                    AppTextarea(title: "Notes", value: $notes)
                    AppButton(title: "Save Reflection") {
                        onSave(TransactionFeedback(satisfaction: Int(satisfaction), regretScore: Int(regretScore), repurchaseLikelihood: nil, usageFrequency: nil, reflection: notes))
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
