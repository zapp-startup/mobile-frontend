import Foundation

struct BankTransaction: Codable, Identifiable, Hashable {
    let id: String
    var connectionId: String
    var accountId: String
    var merchant: String
    var description: String
    var category: String
    var amount: Double
    var currency: String
    var direction: TransactionType
    var date: String
    var valueScore: Int?
    var removed: Bool
}
