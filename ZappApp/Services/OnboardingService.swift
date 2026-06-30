import Foundation

final class OnboardingService {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func checkCompleted() async throws -> Bool {
        let payload: [RawExplicitProfileResponse] = try await apiClient.request(Endpoint.get("/api/raw-explicit/"))
        return !payload.isEmpty
    }

    func submit(profile: FinancialProfile) async throws -> FinancialProfile {
        let request = RawExplicitProfileRequest(
            lifeStage: profile.lifeStage,
            householdSize: profile.householdSize,
            zipCode: profile.zipCode,
            incomeRange: profile.incomeRange,
            monthlyFixedExpenses: profile.monthlyFixedExpenses,
            financialGoal: profile.financialGoal,
            riskTolerance: profile.riskTolerance,
            budgetStyle: profile.budgetStyle,
            spendingPriorities: profile.spendingPriorities,
            researchHabit: profile.researchHabit
        )
        let response: RawExplicitProfileResponse = try await apiClient.request(
            Endpoint.post("/api/raw-explicit/"),
            body: request
        )
        return response.toFinancialProfile()
    }
}

private struct RawExplicitProfileRequest: Encodable {
    let lifeStage: String
    let householdSize: Int
    let zipCode: String
    let incomeRange: String
    let monthlyFixedExpenses: Double
    let financialGoal: String
    let riskTolerance: Int
    let budgetStyle: String
    let spendingPriorities: [String]
    let researchHabit: String
}

private struct RawExplicitProfileResponse: Decodable {
    let lifeStage: String?
    let householdSize: Int?
    let zipCode: String?
    let incomeRange: String?
    let monthlyFixedExpenses: Double?
    let financialGoal: String?
    let riskTolerance: Int?
    let budgetStyle: String?
    let spendingPriorities: [String]?
    let researchHabit: String?

    func toFinancialProfile() -> FinancialProfile {
        FinancialProfile(
            lifeStage: lifeStage ?? "",
            householdSize: householdSize ?? 1,
            zipCode: zipCode ?? "",
            incomeRange: incomeRange ?? "",
            monthlyFixedExpenses: monthlyFixedExpenses ?? 0,
            financialGoal: financialGoal ?? "",
            riskTolerance: riskTolerance ?? 5,
            budgetStyle: budgetStyle ?? "",
            spendingPriorities: spendingPriorities ?? [],
            researchHabit: researchHabit ?? ""
        )
    }
}
