import Foundation

enum AssistantRole: String, Codable, Hashable {
    case user
    case assistant
    case system
}

struct QuickAction: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var title: String
    var prompt: String
}

struct AssistantMessage: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var role: AssistantRole
    var content: String
    var createdAt: String
    var quickActions: [QuickAction]
}
