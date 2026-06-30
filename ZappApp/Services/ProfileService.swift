import Foundation

struct ProfilePayload: Decodable {
    var user: User
    var financialProfile: FinancialProfile
    var preferences: [Preference]
    var privacyMetadata: PrivacyPolicyMetadata?
}

final class ProfileService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchProfile() async throws -> ProfilePayload {
        async let meTask: MeResponse = apiClient.request(Endpoint.get("/api/auth/me/"))
        async let explicitTask: [RawExplicitProfileResponse] = apiClient.request(Endpoint.get("/api/raw-explicit/"))
        async let preferencesTask: [PreferenceResponse] = apiClient.request(Endpoint.get("/api/preferences/"))
        async let privacyTask: PrivacyPolicyMetadata = fetchPrivacyPolicyMetadata()

        let (me, explicit, preferences, privacy) = try await (meTask, explicitTask, preferencesTask, privacyTask)
        return ProfilePayload(
            user: AuthStateResponse.fromMeResponse(me).user,
            financialProfile: explicit.first?.toFinancialProfile() ?? FinancialProfile(
                lifeStage: "",
                householdSize: 1,
                zipCode: "",
                incomeRange: "",
                monthlyFixedExpenses: 0,
                financialGoal: "",
                riskTolerance: 5,
                budgetStyle: "",
                spendingPriorities: [],
                researchHabit: ""
            ),
            preferences: preferences.map { $0.toPreference() },
            privacyMetadata: privacy
        )
    }

    func saveFinancialProfile(_ profile: FinancialProfile) async throws -> FinancialProfile {
        let existing: [RawExplicitProfileResponse] = try await apiClient.request(Endpoint.get("/api/raw-explicit/"))
        let request = RawExplicitProfileRequest(
            lifeStage: profile.lifeStage,
            householdSize: profile.householdSize,
            zipCode: profile.zipCode,
            incomeRange: profile.incomeRange,
            monthlyFixedExpenses: profile.monthlyFixedExpenses,
            financialGoal: profile.financialGoal,
            riskTolerance: profile.riskTolerance,
            budgetStyle: profile.budgetStyle,
            spendingPriorities: profile.spendingPriorities,
            researchHabit: profile.researchHabit
        )
        let response: RawExplicitProfileResponse
        if let first = existing.first, let id = first.id?.stringValue {
            response = try await apiClient.request(Endpoint.patch("/api/raw-explicit/\(id)/"), body: request)
        } else {
            response = try await apiClient.request(Endpoint.post("/api/raw-explicit/"), body: request)
        }
        return response.toFinancialProfile()
    }

    func updateProfileIdentity(fullName: String) async throws -> User {
        let response: MeResponse = try await apiClient.request(
            Endpoint.patch("/api/users/profile/"),
            body: ProfileUpdateRequest(name: fullName)
        )
        return AuthStateResponse.fromMeResponse(response).user
    }

    func addPreference(key: String, value: String, category: String) async throws -> Preference {
        let response: PreferenceResponse = try await apiClient.request(
            Endpoint.post("/api/preferences/"),
            body: PreferenceCreateRequest(key: key, valueType: "string", valueJSON: value, category: category)
        )
        return response.toPreference()
    }

    func deletePreference(id: UUID) async throws {
        let preferences: [PreferenceResponse] = try await apiClient.request(Endpoint.get("/api/preferences/"))
        guard let backendID = preferences.first(where: { $0.toPreference().id == id })?.id.stringValue else {
            throw APIError.server(statusCode: 404, message: "Preference not found.")
        }
        let _: EmptyResponse = try await apiClient.request(Endpoint.delete("/api/preferences/\(backendID)/"))
    }

    func fetchPrivacyPolicyMetadata() async throws -> PrivacyPolicyMetadata {
        try await apiClient.request(Endpoint.get("/api/compliance/privacy-policy/"))
    }

    func enrollMFA() async throws -> Bool {
        let response: MFAEnrollResponse = try await apiClient.request(
            Endpoint.post("/api/auth/mfa/enroll/"),
            body: MFAEnrollRequest(friendlyName: "Profile Enrollment")
        )
        return response.factorId != nil
    }
}

struct PrivacyPolicyMetadata: Decodable, Hashable {
    let policyVersion: String?
    let effectiveDate: String?
    let lastUpdated: String?
    let policyURL: String?
}

private struct ProfileUpdateRequest: Encodable {
    let name: String
}

private struct RawExplicitProfileRequest: Encodable {
    let lifeStage: String
    let householdSize: Int
    let zipCode: String
    let incomeRange: String
    let monthlyFixedExpenses: Double
    let financialGoal: String
    let riskTolerance: Int
    let budgetStyle: String
    let spendingPriorities: [String]
    let researchHabit: String
}

private struct RawExplicitProfileResponse: Decodable {
    let id: FlexibleIdentifier?
    let lifeStage: String?
    let householdSize: Int?
    let zipCode: String?
    let incomeRange: String?
    let monthlyFixedExpenses: Double?
    let financialGoal: String?
    let riskTolerance: Int?
    let budgetStyle: String?
    let spendingPriorities: [String]?
    let researchHabit: String?

    func toFinancialProfile() -> FinancialProfile {
        FinancialProfile(
            lifeStage: lifeStage ?? "",
            householdSize: householdSize ?? 1,
            zipCode: zipCode ?? "",
            incomeRange: incomeRange ?? "",
            monthlyFixedExpenses: monthlyFixedExpenses ?? 0,
            financialGoal: financialGoal ?? "",
            riskTolerance: riskTolerance ?? 5,
            budgetStyle: budgetStyle ?? "",
            spendingPriorities: spendingPriorities ?? [],
            researchHabit: researchHabit ?? ""
        )
    }
}

private struct PreferenceCreateRequest: Encodable {
    let key: String
    let valueType: String
    let valueJSON: String
    let category: String
}

private struct PreferenceResponse: Decodable {
    let id: FlexibleIdentifier
    let key: String
    let value: String?
    let valueJSON: String?
    let category: String?

    func toPreference() -> Preference {
        Preference(
            id: stablePreferenceUUID("pref-\(id.stringValue)"),
            backendID: id.stringValue,
            key: key,
            value: value ?? valueJSON ?? "",
            category: category ?? "general"
        )
    }
}

private func stablePreferenceUUID(_ input: String) -> UUID {
    var hash: UInt64 = 0xcbf29ce484222325
    for byte in input.utf8 {
        hash = (hash ^ UInt64(byte)) &* 0x100000001b3
    }
    let hex = String(format: "%016llx%016llx", hash, hash ^ 0x9ddfea08eb382d69)
    let formatted = "\(hex.prefix(8))-\(hex.dropFirst(8).prefix(4))-\(hex.dropFirst(12).prefix(4))-\(hex.dropFirst(16).prefix(4))-\(hex.dropFirst(20).prefix(12))"
    return UUID(uuidString: formatted) ?? UUID()
}
