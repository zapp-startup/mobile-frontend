import Foundation

final class SpotifyService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchConnectionStatus() async throws -> SpotifyConnection {
        let status: SpotifyStatusResponse = try await apiClient.request(Endpoint.get("/api/integrations/spotify/status/"))
        let insights = try? await fetchInsights()
        return status.toConnection(insightsSummary: insights?.summaryLine)
    }

    func connect(callbackPath: String = "/subscriptions/spotify/callback") async throws -> URL {
        let response: SpotifyConnectResponse = try await apiClient.request(
            Endpoint.post("/api/integrations/spotify/connect/"),
            body: SpotifyConnectRequest(redirectAfter: callbackPath)
        )
        guard let url = URL(string: response.authorizationURL ?? response.redirectURL ?? response.url ?? response.authURL ?? "") else {
            throw APIError.server(statusCode: 500, message: "Spotify authorization URL missing from backend response.")
        }
        return url
    }

    func sync() async throws -> SpotifyConnection {
        let _: SpotifySyncResponse = try await apiClient.request(Endpoint.post("/api/integrations/spotify/sync/"))
        return try await fetchConnectionStatus()
    }

    func disconnect() async throws -> SpotifyConnection {
        let _: EmptyResponse = try await apiClient.request(Endpoint.delete("/api/integrations/spotify/disconnect/"))
        return try await fetchConnectionStatus()
    }

    func fetchInsights() async throws -> SpotifyInsights {
        try await apiClient.request(Endpoint.get("/api/integrations/spotify/insights/"))
    }

    func resolveCallbackAndRefresh() async throws -> SpotifyConnection {
        try await fetchConnectionStatus()
    }
}

private struct SpotifyConnectRequest: Encodable {
    let redirectAfter: String
}

private struct SpotifyConnectResponse: Decodable {
    let authorizationURL: String?
    let redirectURL: String?
    let url: String?
    let authURL: String?
}

private struct SpotifySyncResponse: Decodable {
    let ok: Bool?
}

private struct SpotifyStatusResponse: Decodable {
    let connected: Bool?
    let syncStatus: String?
    let lastSyncedAt: String?
    let profile: SpotifyProfileResponse?
    let lastError: String?

    func toConnection(insightsSummary: String?) -> SpotifyConnection {
        let status: SpotifyConnectionStatus
        if connected == true {
            status = syncStatus == "syncing" ? .syncing : .connected
        } else if lastError != nil {
            status = .error
        } else {
            status = .disconnected
        }

        let message = insightsSummary ?? lastError ?? (connected == true ? "Spotify connected." : "Spotify disconnected.")
        return SpotifyConnection(
            id: stableSpotifyUUID,
            status: status,
            accountName: profile?.displayName,
            product: profile?.product,
            lastSyncedAt: lastSyncedAt,
            statusMessage: message
        )
    }
}

private struct SpotifyProfileResponse: Decodable {
    let displayName: String?
    let product: String?
}

struct SpotifyInsights: Decodable {
    let latestSnapshot: SpotifySnapshot?
    let features: [String: Double]?

    var summaryLine: String {
        if let latestSnapshot {
            return "Insights updated at \(latestSnapshot.computedAt ?? "recently")."
        }
        return "Spotify insights available."
    }
}

struct SpotifySnapshot: Decodable {
    let id: FlexibleIdentifier?
    let computedAt: String?
}

private let stableSpotifyUUID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
