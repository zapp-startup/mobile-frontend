import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    var fullName: String
    var email: String
    var username: String?
    var tier: String
    var initials: String
    var mfaEnabled: Bool
    var createdAt: String

    init(
        id: String,
        fullName: String,
        email: String,
        username: String? = nil,
        tier: String,
        initials: String,
        mfaEnabled: Bool,
        createdAt: String
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.username = username
        self.tier = tier
        self.initials = initials
        self.mfaEnabled = mfaEnabled
        self.createdAt = createdAt
    }
}
