import Foundation

struct Preference: Codable, Identifiable, Hashable {
    let id: UUID
    var backendID: String? = nil
    var key: String
    var value: String
    var category: String
}
