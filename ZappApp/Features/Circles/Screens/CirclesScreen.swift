import SwiftUI

struct CirclesScreen: View {
    @StateObject private var viewModel = CirclesViewModel()
    var onNavigate: (CirclesRoute) -> Void

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(
                    title: "Circles",
                    trailing: AnyView(
                        HStack(spacing: AppSpacing.sm) {
                            Button("Create") { viewModel.showCreateModal = true }
                                .foregroundStyle(AppColors.accent)
                            Button("Join") { viewModel.showJoinModal = true }
                                .foregroundStyle(AppColors.accent)
                        }
                    )
                )
                HStack {
                    AppButton(title: "Badges") { onNavigate(.badges) }
                    AppButton(title: "Targets") { onNavigate(.targets) }
                }
                HStack {
                    AppButton(title: "Weekly Review") { onNavigate(.weeklyReview) }
                    AppButton(title: "Monthly Review") { onNavigate(.monthlyReview) }
                }

                if let success = viewModel.successMessage {
                    StatusChip(text: success, tone: AppColors.success)
                }

                if viewModel.isLoading {
                    AppLoadingState(title: "Loading circles", message: "Syncing your communities.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Circles Error", message: errorMessage) { Task { await viewModel.load() } }
                } else if viewModel.circles.isEmpty {
                    AppEmptyState(title: "No circles yet", message: "Create or join a circle to start group challenges.")
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.circles) { circle in
                                CircleCard(circle: circle) { onNavigate(.circleDetail(circle.id)) }
                            }
                        }
                    }
                }
                Spacer()
            }
            .task { await viewModel.load() }
            .sheet(isPresented: $viewModel.showCreateModal) {
                CreateCircleModal { name, isPrivate in
                    Task { await viewModel.create(name: name, isPrivate: isPrivate) }
                }
            }
            .sheet(isPresented: $viewModel.showJoinModal) {
                JoinCircleModal { inviteCode in
                    Task { await viewModel.join(inviteCode: inviteCode) }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CirclesScreen(onNavigate: { _ in })
    }
}
