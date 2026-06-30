import Foundation

enum TransactionType: String, Codable, CaseIterable, Hashable {
    case spend
    case expense
    case income
    case refund
    case transfer

    var apiDirection: String {
        switch self {
        case .expense:
            return "spend"
        default:
            return rawValue
        }
    }

    var isExpense: Bool {
        self == .spend || self == .expense
    }

    var legacyDisplayName: String {
        switch self {
        case .spend:
            return "expense"
        case .expense:
            return "expense"
        case .income:
            return "income"
        case .refund:
            return "refund"
        case .transfer:
            return "transfer"
        }
    }
}

struct TransactionFeedback: Codable, Hashable {
    var satisfaction: Int?
    var regretScore: Int?
    var repurchaseLikelihood: Int?
    var usageFrequency: String?
    var reflection: String?
}

struct Transaction: Codable, Identifiable, Hashable {
    let id: String
    var description: String
    var merchant: String
    var category: String
    var amount: Double
    var currency: String
    var type: TransactionType
    var date: String
    var valueScore: Int?
    var satisfaction: Int?
    var feedback: TransactionFeedback?
    var source: String
    var createdAt: String
    var updatedAt: String
    var backendDirection: String
    var paymentChannel: String?
}
