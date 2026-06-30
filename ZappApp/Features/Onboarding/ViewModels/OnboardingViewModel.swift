import Foundation

enum OnboardingStep: Int, CaseIterable {
    case lifeStage = 1
    case householdSize = 2
    case zipCode = 3
    case incomeRange = 4
    case monthlyFixedExpenses = 5
    case financialGoal = 6
    case riskTolerance = 7
    case budgetStyle = 8
    case spendingPriorities = 9
    case researchHabit = 10

    var title: String {
        switch self {
        case .lifeStage: return "Life stage"
        case .householdSize: return "Household size"
        case .zipCode: return "Zip code"
        case .incomeRange: return "Income range"
        case .monthlyFixedExpenses: return "Monthly fixed expenses"
        case .financialGoal: return "Financial goal"
        case .riskTolerance: return "Risk tolerance"
        case .budgetStyle: return "Budget style"
        case .spendingPriorities: return "Spending priorities"
        case .researchHabit: return "Research habit"
        }
    }

    var helper: String {
        switch self {
        case .lifeStage: return "This helps personalize benchmarks."
        case .householdSize: return "Include everyone sharing your budget."
        case .zipCode: return "Used for localized spend insights."
        case .incomeRange: return "Choose your annual range."
        case .monthlyFixedExpenses: return "Rent, utilities, recurring bills."
        case .financialGoal: return "What are you optimizing for?"
        case .riskTolerance: return "How comfortable are you with variability?"
        case .budgetStyle: return "Pick your preferred budgeting framework."
        case .spendingPriorities: return "Choose up to 3 priorities."
        case .researchHabit: return "How often do you compare before buying?"
        }
    }
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .lifeStage
    @Published var lifeStage = ""
    @Published var householdSize = ""
    @Published var zipCode = ""
    @Published var incomeRange = ""
    @Published var monthlyFixedExpenses = ""
    @Published var financialGoal = ""
    @Published var riskTolerance: Double = 5
    @Published var budgetStyle = ""
    @Published var spendingPriorities: Set<String> = []
    @Published var researchHabit = ""
    @Published var isSubmitting = false
    @Published var errorMessage: String?
    @Published var didSucceed = false

    let lifeStageOptions = ["Student", "Early Career", "Family Builder", "Established", "Retired"]
    let incomeOptions = ["0-50k", "50k-100k", "100k-150k", "150k-250k", "250k+"]
    let financialGoals = ["Emergency fund", "Debt payoff", "Investing growth", "Big purchase", "Retirement"]
    let budgetStyles = ["50/30/20", "Zero-based", "Envelope", "Flexible"]
    let priorities = ["cost", "quality", "sustainability"]
    let researchHabits = ["Rarely", "Sometimes", "Usually", "Always"]

    private let onboardingService: OnboardingService

    init(onboardingService: OnboardingService = OnboardingService()) {
        self.onboardingService = onboardingService
    }

    var progressText: String {
        "Step \(currentStep.rawValue) of \(OnboardingStep.allCases.count)"
    }

    var isLastStep: Bool {
        currentStep == .researchHabit
    }

    func goBack() {
        guard let previous = OnboardingStep(rawValue: currentStep.rawValue - 1) else { return }
        errorMessage = nil
        currentStep = previous
    }

    func goNext() {
        guard validateCurrentStep() else { return }
        guard let next = OnboardingStep(rawValue: currentStep.rawValue + 1) else { return }
        errorMessage = nil
        currentStep = next
    }

    func togglePriority(_ value: String) {
        if spendingPriorities.contains(value) {
            spendingPriorities.remove(value)
        } else if spendingPriorities.count < 3 {
            spendingPriorities.insert(value)
        }
    }

    func complete(onSuccess: @escaping (FinancialProfile) -> Void) async {
        guard validateCurrentStep(), let profile = buildProfile() else { return }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            let result = try await onboardingService.submit(profile: profile)
            didSucceed = true
            onSuccess(result)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @discardableResult
    func validateCurrentStep() -> Bool {
        switch currentStep {
        case .lifeStage where lifeStage.isEmpty:
            errorMessage = "Select your life stage."
        case .householdSize where Int(householdSize) == nil:
            errorMessage = "Enter a valid household size."
        case .zipCode where zipCode.count < 5:
            errorMessage = "Enter a valid zip code."
        case .incomeRange where incomeRange.isEmpty:
            errorMessage = "Choose an income range."
        case .monthlyFixedExpenses where Double(monthlyFixedExpenses) == nil:
            errorMessage = "Enter valid monthly expenses."
        case .financialGoal where financialGoal.isEmpty:
            errorMessage = "Select a financial goal."
        case .budgetStyle where budgetStyle.isEmpty:
            errorMessage = "Select your budget style."
        case .spendingPriorities where spendingPriorities.isEmpty:
            errorMessage = "Select at least one priority."
        case .researchHabit where researchHabit.isEmpty:
            errorMessage = "Select your research habit."
        default:
            errorMessage = nil
        }
        return errorMessage == nil
    }

    private func buildProfile() -> FinancialProfile? {
        guard
            let household = Int(householdSize),
            let expenses = Double(monthlyFixedExpenses)
        else { return nil }

        return FinancialProfile(
            lifeStage: lifeStage,
            householdSize: household,
            zipCode: zipCode,
            incomeRange: incomeRange,
            monthlyFixedExpenses: expenses,
            financialGoal: financialGoal,
            riskTolerance: Int(riskTolerance),
            budgetStyle: budgetStyle,
            spendingPriorities: Array(spendingPriorities),
            researchHabit: researchHabit
        )
    }
}
