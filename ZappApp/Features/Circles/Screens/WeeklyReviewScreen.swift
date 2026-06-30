import SwiftUI

struct WeeklyReviewScreen: View {
    @StateObject private var viewModel = WeeklyReviewViewModel()
    @State private var promptAnswers: [UUID: String] = [:]

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Weekly Review")
                    if viewModel.isLoading {
                        AppLoadingState(title: "Loading weekly review", message: "Preparing prompts and metrics.")
                    } else if let errorMessage = viewModel.errorMessage {
                        AppErrorState(title: "Review Error", message: errorMessage, retry: nil)
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
                        AppButton(title: "Submit Weekly Review") {
                            Task { await viewModel.submit(summary: promptAnswers) }
                        }
                    } else {
                        AppEmptyState(title: "No weekly review", message: "No review payload available.")
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
