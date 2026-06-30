import Foundation

struct Badge: Codable, Identifiable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var iconName: String
    var unlockedAt: String?
}
