import Foundation

struct BankAccount: Codable, Identifiable, Hashable {
    let id: String
    var connectionId: String
    var name: String
    var type: String
    var mask: String
    var balance: Double
    var currency: String
}
