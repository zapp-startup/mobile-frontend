import SwiftUI

struct SubscriptionsScreen: View {
    @StateObject private var viewModel = SubscriptionsViewModel()
    @StateObject private var spotifyViewModel = SpotifyViewModel()
    var onNavigate: (SubscriptionsRoute) -> Void

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(
                    title: "Subscriptions",
                    trailing: AnyView(Button {
                        onNavigate(.subscriptionForm(nil))
                    } label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(AppColors.accent)
                    })
                )

                SpotifyIntegrationCard(
                    connection: spotifyViewModel.connection,
                    isLoading: spotifyViewModel.isLoading,
                    onConnect: {
                        Task {
                            await spotifyViewModel.connect()
                            onNavigate(.spotifyCallback)
                        }
                    },
                    onSync: { Task { await spotifyViewModel.sync() } },
                    onDisconnect: { Task { await spotifyViewModel.disconnect() } }
                )

                SpotifyInsightsCard(connection: spotifyViewModel.connection)

                if let spotifyError = spotifyViewModel.errorMessage {
                    StatusChip(text: spotifyError, tone: AppColors.error)
                }

                if let successMessage = viewModel.successMessage {
                    StatusChip(text: successMessage, tone: AppColors.success)
                }
                if let spotifySuccess = spotifyViewModel.successMessage {
                    StatusChip(text: spotifySuccess, tone: AppColors.success)
                }

                if viewModel.isLoading {
                    AppLoadingState(title: "Loading subscriptions", message: "Fetching recurring charges.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Subscription error", message: errorMessage) {
                        Task {
                            await viewModel.load()
                            await spotifyViewModel.load()
                        }
                    }
                } else if viewModel.subscriptions.isEmpty {
                    AppEmptyState(title: "No subscriptions", message: "Add a recurring subscription to start tracking value.")
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.subscriptions) { subscription in
                                SubscriptionCard(
                                    subscription: subscription,
                                    onTap: { onNavigate(.subscriptionDetail(subscription.id)) },
                                    onEdit: { onNavigate(.subscriptionForm(subscription.id)) }
                                )
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.load()
                await spotifyViewModel.load()
            }
            .onAppear {
                Task { await viewModel.load() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionsScreen(onNavigate: { _ in })
    }
}
