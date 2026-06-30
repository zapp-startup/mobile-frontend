import Foundation

enum CirclePrivacy: String, Codable, Hashable {
    case `public`
    case `private`
}

struct CircleMember: Codable, Identifiable, Hashable {
    let id: UUID
    var displayName: String
    var rank: Int
    var points: Int
    var isCurrentUser: Bool
}

struct CircleLeaderboardEntry: Codable, Identifiable, Hashable {
    let id: UUID
    var memberName: String
    var rank: Int
    var score: Int
}

struct Circle: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var name: String
    var privacy: CirclePrivacy
    var inviteCode: String
    var memberCount: Int
    var members: [CircleMember]
    var leaderboard: [CircleLeaderboardEntry]
}
