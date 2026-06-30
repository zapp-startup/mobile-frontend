import SwiftUI

struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    var onComplete: () -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Onboarding", subtitle: "Tell us how to personalize Zapp.")
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.lg) {
                            OnboardingStepHeader(
                                title: viewModel.currentStep.title,
                                helper: viewModel.currentStep.helper,
                                progress: viewModel.progressText
                            )
                            stepContent
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
                            }
                            if viewModel.didSucceed {
                                Text("Onboarding complete. Preparing dashboard.")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.success)
                            }
                        }
                    }
                    StepFooter(
                        isFirstStep: viewModel.currentStep == .lifeStage,
                        isLastStep: viewModel.isLastStep,
                        isLoading: viewModel.isSubmitting,
                        onBack: viewModel.goBack,
                        onNext: {
                            if viewModel.isLastStep {
                                Task { await viewModel.complete { _ in onComplete() } }
                            } else {
                                viewModel.goNext()
                            }
                        }
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case .lifeStage:
            OptionButtonGrid(options: viewModel.lifeStageOptions, selected: Set([viewModel.lifeStage].filter { !$0.isEmpty })) { value in
                viewModel.lifeStage = value
            }
        case .householdSize:
            AppInput(title: "Household size", value: $viewModel.householdSize)
        case .zipCode:
            AppInput(title: "Zip code", value: $viewModel.zipCode)
        case .incomeRange:
            OptionButtonGrid(options: viewModel.incomeOptions, selected: Set([viewModel.incomeRange].filter { !$0.isEmpty })) { value in
                viewModel.incomeRange = value
            }
        case .monthlyFixedExpenses:
            AppInput(title: "Monthly fixed expenses", value: $viewModel.monthlyFixedExpenses)
        case .financialGoal:
            OptionButtonGrid(options: viewModel.financialGoals, selected: Set([viewModel.financialGoal].filter { !$0.isEmpty })) { value in
                viewModel.financialGoal = value
            }
        case .riskTolerance:
            SliderQuestion(title: "How much risk can you tolerate?", value: $viewModel.riskTolerance)
        case .budgetStyle:
            OptionButtonGrid(options: viewModel.budgetStyles, selected: Set([viewModel.budgetStyle].filter { !$0.isEmpty })) { value in
                viewModel.budgetStyle = value
            }
        case .spendingPriorities:
            OptionButtonGrid(options: viewModel.priorities, selected: viewModel.spendingPriorities, allowsMultiple: true) { value in
                viewModel.togglePriority(value)
            }
        case .researchHabit:
            OptionButtonGrid(options: viewModel.researchHabits, selected: Set([viewModel.researchHabit].filter { !$0.isEmpty })) { value in
                viewModel.researchHabit = value
            }
        }
    }
}
