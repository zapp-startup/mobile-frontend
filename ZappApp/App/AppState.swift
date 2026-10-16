import Foundation

enum AuthStep {
    case login
    case signUp
    case callback
    case mfaSetup
    case mfaVerify
}

final class AppState: ObservableObject {
    enum BackendNextStep: String {
        case mfaSetup = "mfa_setup"
        case mfaVerify = "mfa_verify"
        case onboardingSurvey = "onboarding_survey"
    }

    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var hasCompletedOnboarding = false
    @Published var requiresMFASetup = false
    @Published var requiresMFAVerification = false
    @Published var currentAuthStep: AuthStep = .login
    @Published var mfaPending = false
    @Published var mfaEnrollmentRequired = false
    @Published var backendNextStep: BackendNextStep?
    @Published var postMfaStep: BackendNextStep?
    @Published var authToken: String?
    @Published var authAssurance: AuthAssuranceResponse?
    @Published var oauthCallbackURL: URL?

    private let authService = AuthService()
    private let onboardingService = OnboardingService()

    init() {
        bootstrap()
    }

    func bootstrap() {
        isLoading = true
        Task {
            do {
                let session = try await authService.bootstrapSession()
                let isOnboardingCompleted = (try? await onboardingService.checkCompleted()) ?? session.onboardingCompleted
                await MainActor.run {
                    applyAuthState(session, onboardingCompletedOverride: isOnboardingCompleted)
                    isLoading = false
                }
            } catch APIError.unauthorized {
                await MainActor.run {
                    isLoading = false
                    logout()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    logout()
                }
            }
        }
    }

    func applyAuthenticatedSession(user: User, token: String?) {
        self.user = user
        isAuthenticated = true
        requiresMFASetup = false
        requiresMFAVerification = false
        mfaPending = false
        mfaEnrollmentRequired = false
        backendNextStep = nil
        postMfaStep = nil
        authToken = token
    }

    func updateAuthProgress(
        mfaPending: Bool,
        mfaEnrollmentRequired: Bool,
        nextStep: String?,
        postMfaStep: String?
    ) {
        self.mfaPending = mfaPending
        self.mfaEnrollmentRequired = mfaEnrollmentRequired
        self.backendNextStep = nextStep.flatMap(BackendNextStep.init(rawValue:))
        self.postMfaStep = postMfaStep.flatMap(BackendNextStep.init(rawValue:))
        self.requiresMFASetup = mfaEnrollmentRequired || backendNextStep == .mfaSetup
        self.requiresMFAVerification = mfaPending || backendNextStep == .mfaVerify
    }

    func applyAuthState(_ state: AuthStateResponse, onboardingCompletedOverride: Bool? = nil) {
        user = state.user
        isAuthenticated = true
        hasCompletedOnboarding = onboardingCompletedOverride ?? state.onboardingCompleted
        updateAuthProgress(
            mfaPending: state.mfaPending,
            mfaEnrollmentRequired: state.mfaEnrollmentRequired,
            nextStep: state.nextStep,
            postMfaStep: state.postMfaStep
        )
        currentAuthStep = routeForNextStep()
    }

    func routeForNextStep() -> AuthStep {
        if requiresMFASetup {
            return .mfaSetup
        }
        if requiresMFAVerification {
            return .mfaVerify
        }
        return .login
    }

    func logout() {
        user = nil
        isAuthenticated = false
        hasCompletedOnboarding = false
        requiresMFASetup = false
        requiresMFAVerification = false
        mfaPending = false
        mfaEnrollmentRequired = false
        backendNextStep = nil
        postMfaStep = nil
        currentAuthStep = .login
        authToken = nil
        oauthCallbackURL = nil
    }

    func handleOAuthCallback(_ url: URL) {
        oauthCallbackURL = url
        currentAuthStep = .callback
    }
}
