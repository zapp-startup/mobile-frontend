import SwiftUI

struct TargetsScreen: View {
    @StateObject private var viewModel = TargetsViewModel()
    @State private var showCreateTarget = false

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Targets")
                if viewModel.isLoading {
                    AppLoadingState(title: "Loading targets", message: "Fetching target progress.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Targets Error", message: errorMessage, retry: nil)
                } else if viewModel.targets.isEmpty {
                    AppEmptyState(title: "No targets yet", message: "Create your first savings or budgeting target.")
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.targets) { target in
                                TargetCard(target: target)
                                    .onTapGesture {
                                        Task { await viewModel.incrementProgress(for: target) }
                                    }
                            }
                        }
                    }
                }
                if let successMessage = viewModel.successMessage {
                    StatusChip(text: successMessage, tone: AppColors.success)
                }
                AppButton(title: "Create Target") {
                    showCreateTarget = true
                }
                Spacer()
            }
            .task { await viewModel.load() }
            .sheet(isPresented: $showCreateTarget) {
                CreateTargetModal { title, amount in
                    Task { await viewModel.createTarget(title: title, targetValue: amount) }
                }
            }
        }
    }
}
