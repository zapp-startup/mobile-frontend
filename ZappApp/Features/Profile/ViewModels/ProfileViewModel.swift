import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var payload: ProfilePayload?
    @Published var showAddPreference = false

    private let service: ProfileService
    private let authService: AuthService

    init(
        service: ProfileService = ProfileService(),
        authService: AuthService = AuthService()
    ) {
        self.service = service
        self.authService = authService
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            payload = try await service.fetchProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveProfile() async {
        guard let profile = payload?.financialProfile else { return }
        do {
            let updated = try await service.saveFinancialProfile(profile)
            payload?.financialProfile = updated
            if let fullName = payload?.user.fullName, !fullName.isEmpty {
                payload?.user = try await service.updateProfileIdentity(fullName: fullName)
            }
            successMessage = "Profile saved."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addPreference(key: String, value: String, category: String) async {
        do {
            let preference = try await service.addPreference(key: key, value: value, category: category)
            payload?.preferences.append(preference)
            successMessage = "Preference added."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removePreference(_ preference: Preference) async {
        do {
            try await service.deletePreference(id: preference.id)
            payload?.preferences.removeAll { $0.id == preference.id }
            successMessage = "Preference removed."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func enrollMFA() async {
        do {
            let ok = try await service.enrollMFA()
            successMessage = ok ? "MFA enrollment started." : "MFA enrollment unavailable."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() async throws {
        try await authService.logout()
    }
}
