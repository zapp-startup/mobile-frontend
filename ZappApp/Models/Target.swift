import Foundation

enum TargetStatus: String, Codable, Hashable {
    case active
    case completed
    case paused
}

struct Target: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var title: String
    var type: String
    var targetValue: Double
    var currentValue: Double
    var unit: String
    var status: TargetStatus
}
