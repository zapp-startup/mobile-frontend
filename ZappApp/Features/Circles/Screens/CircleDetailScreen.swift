import SwiftUI

struct CircleDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var listViewModel = CirclesViewModel()
    @StateObject private var detailViewModel = CircleDetailViewModel()
    let circleId: UUID

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Circle Detail")
                    if let errorMessage = detailViewModel.errorMessage {
                        AppErrorState(title: "Circle unavailable", message: errorMessage, retry: nil)
                    } else if let circle = detailViewModel.circle {
                        InviteCodeCard(inviteCode: circle.inviteCode)
                        AppCard {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                SectionHeader(title: "Members")
                                ForEach(circle.members) { member in
                                    MemberRow(member: member)
                                }
                            }
                        }
                        AppCard {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                SectionHeader(title: "Leaderboard")
                                ForEach(circle.leaderboard) { entry in
                                    LeaderboardRow(entry: entry)
                                }
                            }
                        }
                        Button("Leave Circle") {
                            Task {
                                await listViewModel.leave(circleId: circle.id)
                                dismiss()
                            }
                        }
                        .foregroundStyle(AppColors.error)
                    } else {
                        AppLoadingState(title: "Loading circle", message: "Fetching members and leaderboard.")
                    }
                }
                .task {
                    await listViewModel.load()
                    detailViewModel.bind(circleId: circleId, source: listViewModel.circles)
                }
            }
        }
    }
}
