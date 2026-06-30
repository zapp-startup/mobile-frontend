import Foundation

enum MFAFactorType: String, Codable {
    case totp
}

struct MFAFactor: Codable, Hashable, Identifiable {
    let id: String
    let factorType: MFAFactorType
    let friendlyName: String?
    let status: String?
    let createdAt: String?

    var displayName: String {
        friendlyName ?? "Authenticator App"
    }
}

struct AuthSession: Codable {
    var user: User
    var token: String?
    var requiresMFASetup: Bool
    var requiresMFAVerification: Bool
}

final class AuthService {
    private let apiClient: APIClient
    private let mfaService: MFAService
    private let complianceService: ComplianceService

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
        self.mfaService = MFAService(apiClient: apiClient)
        self.complianceService = ComplianceService(apiClient: apiClient)
    }

    func bootstrapSession() async throws -> AuthStateResponse {
        try await me()
    }

    func login(email: String, password: String) async throws -> AuthStateResponse {
        _ = try await apiClient.request(Endpoint.get("/api/auth/csrf/")) as CSRFBootstrapResponse
        return try await apiClient.request(
            Endpoint.post("/api/auth/login/"),
            body: LoginRequest(email: email, password: password)
        )
    }

    func signUp(fullName: String, email: String, password: String) async throws -> AuthStateResponse {
        let response: SignupResponse = try await apiClient.request(
            Endpoint.post("/api/auth/signup/"),
            body: SignupRequest(email: email, password: password)
        )
        guard response.requiresVerification != true else {
            throw APIError.server(statusCode: 400, message: response.detail ?? "Email verification required before signing in.")
        }
        return try await me()
    }

    func startGoogleOAuth(redirectURIAfter: String) async throws -> URL {
        let response: OAuthStartResponse = try await apiClient.request(
            Endpoint.post("/api/auth/oauth/start/"),
            body: OAuthStartRequest(provider: "google", redirectURIAfter: redirectURIAfter)
        )
        guard let url = URL(string: response.authorizeURL) else {
            throw APIError.server(statusCode: 500, message: "Invalid OAuth authorize URL from backend.")
        }
        return url
    }

    func googleOAuthBrowserStartURL(redirectURIAfter: String) throws -> URL {
        guard var components = URLComponents(
            url: APIClient.configuredBaseURL.appendingPathComponent("api/auth/oauth/start/"),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "provider", value: "google"),
            URLQueryItem(name: "redirect_uri_after", value: redirectURIAfter)
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        #if DEBUG
        print("[OAuth Debug] Built browser start URL: \(url.absoluteString)")
        #endif
        return url
    }

    func me() async throws -> AuthStateResponse {
        let response: MeResponse = try await apiClient.request(Endpoint.get("/api/auth/me/"))
        return AuthStateResponse.fromMeResponse(response)
    }

    func logout() async throws {
        let _: EmptyResponse = try await apiClient.request(Endpoint.post("/api/auth/logout/"))
    }

    func mfaSnapshot() async throws -> MFASnapshotResponse {
        try await mfaService.snapshot()
    }

    func enrollMFA(friendlyName: String?) async throws -> MFAEnrollResponse {
        try await mfaService.enroll(friendlyName: friendlyName)
    }

    func verifyEnrollment(factorId: String, code: String) async throws -> MFAEnrollmentVerifyResponse {
        try await mfaService.verifyEnrollment(factorId: factorId, code: code)
    }

    func createMFAChallenge(factorId: String) async throws -> MFAChallengeResponse {
        try await mfaService.challenge(factorId: factorId)
    }

    func verifyMFAChallenge(factorId: String, challengeId: String, code: String) async throws -> AuthStateResponse {
        let _: MFAVerifyResponse = try await mfaService.verify(factorId: factorId, challengeId: challengeId, code: code)
        return try await me()
    }

    func unenrollMFA(factorId: String) async throws {
        try await mfaService.unenroll(factorId: factorId)
    }

    func authAssurance() async throws -> AuthAssuranceResponse {
        try await complianceService.authAssurance()
    }
}

final class MFAService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func snapshot() async throws -> MFASnapshotResponse {
        try await apiClient.request(Endpoint.get("/api/auth/mfa/snapshot/"))
    }

    func enroll(friendlyName: String?) async throws -> MFAEnrollResponse {
        try await apiClient.request(
            Endpoint.post("/api/auth/mfa/enroll/"),
            body: MFAEnrollRequest(friendlyName: friendlyName)
        )
    }

    func verifyEnrollment(factorId: String, code: String) async throws -> MFAEnrollmentVerifyResponse {
        try await apiClient.request(
            Endpoint.post("/api/auth/mfa/verify-enrollment/"),
            body: MFAEnrollmentVerifyRequest(factorId: factorId, code: code)
        )
    }

    func challenge(factorId: String) async throws -> MFAChallengeResponse {
        try await apiClient.request(
            Endpoint.post("/api/auth/mfa/challenge/"),
            body: MFAChallengeRequest(factorId: factorId)
        )
    }

    func verify(factorId: String, challengeId: String, code: String) async throws -> MFAVerifyResponse {
        try await apiClient.request(
            Endpoint.post("/api/auth/mfa/verify/"),
            body: MFAVerifyRequest(factorId: factorId, challengeId: challengeId, code: code)
        )
    }

    func unenroll(factorId: String) async throws {
        let _: EmptyResponse = try await apiClient.request(Endpoint.delete("/api/auth/mfa/factors/\(factorId)/"))
    }
}

final class ComplianceService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func authAssurance() async throws -> AuthAssuranceResponse {
        do {
            return try await apiClient.request(Endpoint.get("/api/security/auth-assurance/"))
        } catch {
            return try await apiClient.request(Endpoint.get("/api/auth/assurance/"))
        }
    }

    func consentStatus() async throws -> ConsentStatusResponse {
        try await apiClient.request(Endpoint.get("/api/compliance/consent/status/"))
    }

    func recordConsent(consentText: String, source: String = "ios") async throws {
        let _: EmptyResponse = try await apiClient.request(
            Endpoint.post("/api/compliance/consent/"),
            body: ConsentRecordRequest(consentText: consentText, source: source)
        )
    }
}

// MARK: - Auth DTOs

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct SignupRequest: Encodable {
    let email: String
    let password: String
}

struct SignupResponse: Decodable {
    let requiresVerification: Bool?
    let detail: String?
}

struct OAuthStartRequest: Encodable {
    let provider: String
    let redirectURIAfter: String
}

struct OAuthStartResponse: Decodable {
    let authorizeURL: String

    enum CodingKeys: String, CodingKey {
        case authorizeURL = "authorize_url"
        case authorizeUrl
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let value = try container.decodeIfPresent(String.self, forKey: .authorizeURL), !value.isEmpty {
            authorizeURL = value
            return
        }
        if let value = try container.decodeIfPresent(String.self, forKey: .authorizeUrl), !value.isEmpty {
            authorizeURL = value
            return
        }
        if let value = try container.decodeIfPresent(String.self, forKey: .url), !value.isEmpty {
            authorizeURL = value
            return
        }

        throw DecodingError.keyNotFound(
            CodingKeys.authorizeURL,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Missing OAuth authorize URL in response.")
        )
    }
}

struct MeResponse: Decodable {
    let id: FlexibleIdentifier
    let email: String
    let username: String?
    let name: String?
    let tier: String?
    let mfaPending: Bool?
    let mfaEnrollmentRequired: Bool?
    let nextStep: String?
    let postMfaStep: String?
    let onboardingCompleted: Bool?
    let onboardingRequired: Bool?
    let createdAt: String?
}

struct AuthStateResponse: Decodable {
    let user: User
    let mfaPending: Bool
    let mfaEnrollmentRequired: Bool
    let nextStep: String?
    let postMfaStep: String?
    let onboardingCompleted: Bool
    let onboardingRequired: Bool

    static func fromMeResponse(_ me: MeResponse) -> AuthStateResponse {
        let displayName = me.name ?? me.username ?? me.email
        let initials = displayName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map { String($0) } }
            .joined()
            .uppercased()

        let user = User(
            id: me.id.stringValue,
            fullName: displayName,
            email: me.email,
            username: me.username,
            tier: me.tier ?? "free",
            initials: initials.isEmpty ? "ZU" : initials,
            mfaEnabled: !(me.mfaEnrollmentRequired ?? false),
            createdAt: me.createdAt ?? ""
        )

        return AuthStateResponse(
            user: user,
            mfaPending: me.mfaPending ?? false,
            mfaEnrollmentRequired: me.mfaEnrollmentRequired ?? false,
            nextStep: me.nextStep,
            postMfaStep: me.postMfaStep,
            onboardingCompleted: me.onboardingCompleted ?? false,
            onboardingRequired: me.onboardingRequired ?? true
        )
    }
}

struct CSRFBootstrapResponse: Decodable {
    let detail: String?
}

// MARK: - MFA DTOs

struct MFASnapshotResponse: Decodable {
    let factors: [MFAFactor]
    let currentLevel: String?
}

struct MFAEnrollRequest: Encodable {
    let friendlyName: String?
}

struct MFAEnrollResponse: Decodable {
    let factorId: String?
    let qrCode: String?
    let otpauthUrl: String?
}

struct MFAEnrollmentVerifyRequest: Encodable {
    let factorId: String
    let code: String
}

struct MFAEnrollmentVerifyResponse: Decodable {
    let detail: String?
    let verified: Bool?
}

struct MFAChallengeRequest: Encodable {
    let factorId: String
}

struct MFAChallengeResponse: Decodable {
    let challengeId: String
    let factorId: String?
}

struct MFAVerifyRequest: Encodable {
    let factorId: String
    let challengeId: String
    let code: String
}

struct MFAVerifyResponse: Decodable {
    let detail: String?
}

// MARK: - Compliance DTOs

struct AuthAssuranceResponse: Decodable {
    let canLinkBank: Bool?
    let blockingCode: String?
    let mfaRequired: Bool?
    let mfaPending: Bool?
}

struct ConsentStatusResponse: Decodable {
    let consentRequired: Bool?
    let hasValidConsent: Bool?
    let currentPolicyVersion: String?
    let consentText: String?
}

struct ConsentRecordRequest: Encodable {
    let consentText: String
    let source: String
}

enum FlexibleIdentifier: Codable, Hashable {
    case int(Int)
    case string(String)

    var stringValue: String {
        switch self {
        case .int(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }
        self = .string(try container.decode(String.self))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
