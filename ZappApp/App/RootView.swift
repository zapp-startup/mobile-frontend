import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab: AppTab = .home
    @State private var showAssistant = false
    @State private var showBuyAdvisor = false
    @State private var transactionsPath: [TransactionsRoute] = []
    @State private var subscriptionsPath: [SubscriptionsRoute] = []
    @State private var circlesPath: [CirclesRoute] = []
    @State private var profilePath: [ProfileRoute] = []

    var body: some View {
        Group {
            if appState.isLoading {
                AppLoadingState(title: "Launching Zapp", message: "Preparing your secure finance workspace.")
            } else if !appState.isAuthenticated {
                authFlow
            } else if !appState.hasCompletedOnboarding {
                OnboardingScreen {
                    appState.hasCompletedOnboarding = true
                }
            } else {
                mainTabs
            }
        }
        .sheet(isPresented: $showAssistant) {
            AssistantScreen()
        }
        .sheet(isPresented: $showBuyAdvisor) {
            BuyAdvisorModal()
        }
    }

    @ViewBuilder
    private var authFlow: some View {
        switch appState.currentAuthStep {
        case .login:
            LoginScreen(
                onSignUp: { appState.currentAuthStep = .signUp },
                onLogin: { state in
                    appState.applyAuthState(state)
                },
                onOAuthCallback: { callbackURL in
                    appState.handleOAuthCallback(callbackURL)
                }
            )
        case .signUp:
            SignUpScreen(
                onSignIn: { appState.currentAuthStep = .login },
                onComplete: { state in
                    appState.applyAuthState(state)
                }
            )
        case .callback:
            AuthCallbackScreen()
        case .mfaSetup:
            MfaSetupScreen {
                appState.currentAuthStep = .mfaVerify
            }
        case .mfaVerify:
            MfaVerifyScreen { state in
                appState.applyAuthState(state)
            }
        }
    }

    private var mainTabs: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeScreen(
                    onOpenAnalytics: { profilePath = [.analytics]; selectedTab = .profile },
                    onOpenAssistant: { showAssistant = true },
                    onOpenSearch: { profilePath = [.search]; selectedTab = .profile },
                    onOpenBuyAdvisor: { showBuyAdvisor = true }
                )
            }
            .tabItem { TabIcon(tab: .home, isSelected: selectedTab == .home) }
            .tag(AppTab.home)

            NavigationStack(path: $transactionsPath) {
                TransactionsScreen(onNavigate: { route in transactionsPath.append(route) })
                    .navigationDestination(for: TransactionsRoute.self) { route in
                        switch route {
                        case .transactionDetail(let transactionId):
                            TransactionDetailScreen(transactionId: transactionId)
                        case .transactionForm(let transactionId):
                            TransactionFormScreen(transactionId: transactionId)
                        case .bankingConnections: BankingConnectionsScreen()
                        case .bankConnectionDetail(let connectionId):
                            BankConnectionDetailScreen(connectionId: connectionId)
                        case .bankTransactions(let connectionId):
                            BankTransactionsScreen(connectionId: connectionId)
                        }
                    }
            }
            .tabItem { TabIcon(tab: .transactions, isSelected: selectedTab == .transactions) }
            .tag(AppTab.transactions)

            NavigationStack(path: $subscriptionsPath) {
                SubscriptionsScreen(onNavigate: { route in subscriptionsPath.append(route) })
                    .navigationDestination(for: SubscriptionsRoute.self) { route in
                        switch route {
                        case .subscriptionDetail(let subscriptionId):
                            SubscriptionDetailScreen(subscriptionId: subscriptionId)
                        case .subscriptionForm(let subscriptionId):
                            SubscriptionFormScreen(subscriptionId: subscriptionId)
                        case .spotifyCallback: SpotifyCallbackScreen()
                        }
                    }
            }
            .tabItem { TabIcon(tab: .subscriptions, isSelected: selectedTab == .subscriptions) }
            .tag(AppTab.subscriptions)

            NavigationStack(path: $circlesPath) {
                CirclesScreen(onNavigate: { route in circlesPath.append(route) })
                    .navigationDestination(for: CirclesRoute.self) { route in
                        switch route {
                        case .circleDetail(let circleId): CircleDetailScreen(circleId: circleId)
                        case .badges: BadgesScreen()
                        case .targets: TargetsScreen()
                        case .weeklyReview: WeeklyReviewScreen()
                        case .monthlyReview: MonthlyReviewScreen()
                        }
                    }
            }
            .tabItem { TabIcon(tab: .circles, isSelected: selectedTab == .circles) }
            .tag(AppTab.circles)

            NavigationStack(path: $profilePath) {
                ProfileScreen(onNavigate: { route in profilePath.append(route) })
                    .navigationDestination(for: ProfileRoute.self) { route in
                        switch route {
                        case .search: SearchScreen()
                        case .privacy: PrivacyPolicyScreen()
                        case .analytics: AnalyticsScreen()
                        }
                    }
            }
            .tabItem { TabIcon(tab: .profile, isSelected: selectedTab == .profile) }
            .tag(AppTab.profile)
        }
        .tint(AppColors.accent)
    }
}
