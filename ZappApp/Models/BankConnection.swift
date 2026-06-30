import Foundation

enum BankConnectionStatus: String, Codable, Hashable {
    case active
    case syncing
    case consentRequired
    case mfaRequired
    case error
}

struct BankConnection: Codable, Identifiable, Hashable {
    let id: String
    var institutionName: String
    var institutionId: String
    var status: BankConnectionStatus
    var lastSyncedAt: String?
    var canSync: Bool
    var requiresConsent: Bool
    var requiresMFA: Bool
}
