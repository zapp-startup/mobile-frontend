import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = ProfileViewModel()
    var onNavigate: (ProfileRoute) -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Profile")

                    if viewModel.isLoading && viewModel.payload == nil {
                        AppLoadingState(title: "Loading profile", message: "Fetching profile, preferences, and settings.")
                    } else if let errorMessage = viewModel.errorMessage, viewModel.payload == nil {
                        AppErrorState(title: "Profile Error", message: errorMessage) { Task { await viewModel.load() } }
                    } else if let payload = viewModel.payload {
                        ProfileIdentityCard(user: payload.user)
                        FinancialProfileCard(
                            profile: Binding(
                                get: { payload.financialProfile },
                                set: { viewModel.payload?.financialProfile = $0 }
                            ),
                            onSave: { Task { await viewModel.saveProfile() } }
                        )
                        PreferencesList(
                            preferences: payload.preferences,
                            onAdd: { viewModel.showAddPreference = true },
                            onRemove: { preference in Task { await viewModel.removePreference(preference) } }
                        )
                        MfaEnrollmentCard(
                            isEnabled: payload.user.mfaEnabled,
                            onEnroll: { Task { await viewModel.enrollMFA() } }
                        )

                        SettingsRow(title: "Analytics") { onNavigate(.analytics) }
                        SettingsRow(title: "Search") { onNavigate(.search) }
                        SettingsRow(title: "Privacy") { onNavigate(.privacy) }
                        AppButton(title: "Logout") {
                            Task {
                                try? await viewModel.logout()
                                appState.logout()
                            }
                        }
                    }

                    if let successMessage = viewModel.successMessage {
                        StatusChip(text: successMessage, tone: AppColors.success)
                    }
                    if let errorMessage = viewModel.errorMessage, viewModel.payload != nil {
                        StatusChip(text: errorMessage, tone: AppColors.error)
                    }
                }
            }
            .task { await viewModel.load() }
            .sheet(isPresented: $viewModel.showAddPreference) {
                AddPreferenceSheet { key, value, category in
                    Task { await viewModel.addPreference(key: key, value: value, category: category) }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileScreen(onNavigate: { _ in })
            .environmentObject(AppState())
    }
}
