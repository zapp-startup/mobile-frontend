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
        successMessage = nil
        do {
            payload = try await service.fetchProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveProfile() async {
        guard let profile = payload?.financialProfile else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let updated = try await service.saveFinancialProfile(profile)
            payload?.financialProfile = updated
            // Identity (name) PATCH intentionally omitted: there is no name-edit UI,
            // so the name is always unchanged and PATCHing it is a wasted request.
            // Re-add updateProfileIdentity here, guarded by a change comparison,
            // once an editable name field exists. (DEFERRED)
            successMessage = "Profile saved."
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            successMessage = nil
        }
    }

    func addPreference(key: String, value: String, category: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let preference = try await service.addPreference(key: key, value: value, category: category)
            payload?.preferences.append(preference)
            successMessage = "Preference added."
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            successMessage = nil
        }
    }

    func removePreference(_ preference: Preference) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await service.deletePreference(id: preference.id)
            payload?.preferences.removeAll { $0.id == preference.id }
            successMessage = "Preference removed."
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            successMessage = nil
        }
    }

    func enrollMFA() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let ok = try await service.enrollMFA()
            if ok {
                await load()
                successMessage = "Enrollment started — check your authenticator app."
                errorMessage = nil
            } else {
                errorMessage = "MFA enrollment unavailable."
                successMessage = nil
            }
        } catch {
            errorMessage = error.localizedDescription
            successMessage = nil
        }
    }

    func logout() async throws {
        try await authService.logout()
    }
}
