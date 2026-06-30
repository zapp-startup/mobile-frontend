import Foundation

enum SpotifyConnectionStatus: String, Codable, Hashable {
    case disconnected
    case connected
    case syncing
    case error
}

struct SpotifyConnection: Codable, Identifiable, Hashable {
    let id: UUID
    var status: SpotifyConnectionStatus
    var accountName: String?
    var product: String?
    var lastSyncedAt: String?
    var statusMessage: String
}
