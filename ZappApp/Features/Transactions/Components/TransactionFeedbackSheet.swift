import SwiftUI

struct TransactionFeedbackSheet: View {
    @State private var satisfaction = 70.0
    @State private var regretScore = 2.0
    @State private var repurchase = 6.0
    @State private var usageFrequency = "weekly"
    @State private var reflection = ""
    var onSubmit: (TransactionFeedback) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Transaction Feedback", subtitle: "Capture post-purchase sentiment.")
                    SliderQuestion(title: "Satisfaction", value: $satisfaction)
                    SliderQuestion(title: "Regret score", value: $regretScore)
                    SliderQuestion(title: "Repurchase likelihood", value: $repurchase)
                    AppInput(title: "Usage frequency", value: $usageFrequency)
                    AppTextarea(title: "Reflection", value: $reflection)
                    AppButton(title: "Submit Feedback") {
                        let payload = TransactionFeedback(
                            satisfaction: Int(satisfaction),
                            regretScore: Int(regretScore),
                            repurchaseLikelihood: Int(repurchase),
                            usageFrequency: usageFrequency,
                            reflection: reflection
                        )
                        onSubmit(payload)
                    }
                    Spacer()
                }
            }
        }
    }
}
