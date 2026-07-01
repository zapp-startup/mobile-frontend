import SwiftUI

struct MonthlyReviewScreen: View {
    @StateObject private var viewModel = MonthlyReviewViewModel()
    @State private var promptAnswers: [UUID: String] = [:]

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Monthly Review")
                    if viewModel.isLoading {
                        AppLoadingState(title: "Loading monthly review", message: "Preparing monthly reflection prompts.")
                    } else if let errorMessage = viewModel.errorMessage {
                        AppErrorState(title: "Review Error", message: errorMessage, retry: { Task { await viewModel.load() } })
                    } else if let review = viewModel.review {
                        AppCard {
                            HStack {
                                Text("Reviewed: \(review.reviewedCount)")
                                Spacer()
                                Text("Pending: \(review.pendingCount)")
                            }
                        }
                        ForEach(review.prompts) { prompt in
                            AppTextarea(
                                title: prompt.question,
                                value: Binding(
                                    get: { promptAnswers[prompt.id] ?? prompt.answer ?? "" },
                                    set: { promptAnswers[prompt.id] = $0 }
                                )
                            )
                        }
                        AppButton(title: "Open Reflection Dialog") { viewModel.showReflection = true }
                        if let success = viewModel.successMessage {
                            StatusChip(text: success, tone: AppColors.success)
                        }
                        AppButton(title: "Submit Monthly Review") {
                            Task { await viewModel.submit(summary: promptAnswers) }
                        }
                    } else {
                        AppEmptyState(title: "No monthly review", message: "No review payload available.")
                    }
                }
            }
            .task { await viewModel.load() }
            .sheet(isPresented: $viewModel.showReflection) {
                ReflectionDialog { feedback in
                    Task { await viewModel.saveReflection(feedback) }
                }
            }
        }
    }
}
