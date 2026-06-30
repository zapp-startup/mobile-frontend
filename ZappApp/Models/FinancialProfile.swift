import Foundation

struct FinancialProfile: Codable, Hashable {
    var lifeStage: String
    var householdSize: Int
    var zipCode: String
    var incomeRange: String
    var monthlyFixedExpenses: Double
    var financialGoal: String
    var riskTolerance: Int
    var budgetStyle: String
    var spendingPriorities: [String]
    var researchHabit: String
}
