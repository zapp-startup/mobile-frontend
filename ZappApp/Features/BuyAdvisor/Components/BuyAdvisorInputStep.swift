import SwiftUI

struct BuyAdvisorInputStep: View {
    @ObservedObject var viewModel: BuyAdvisorViewModel

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            AppHeader(title: "Buy Advisor", subtitle: "Input your predicted purchase details.")
            AppInput(title: "Predicted price", value: $viewModel.predictedPrice, keyboardType: .decimalPad)
            AppInput(title: "Target category", value: $viewModel.category)
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).font(AppTypography.caption).foregroundStyle(AppColors.error)
            }
            AppButton(title: "Analyze") { Task { await viewModel.analyze() } }
        }
    }
}
