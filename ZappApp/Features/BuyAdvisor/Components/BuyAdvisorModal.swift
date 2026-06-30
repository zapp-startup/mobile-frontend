import SwiftUI

struct BuyAdvisorModal: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = BuyAdvisorViewModel()

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack {
                    switch viewModel.step {
                    case .input:
                        BuyAdvisorInputStep(viewModel: viewModel)
                    case .loading:
                        BuyAdvisorLoadingStep()
                    case .result:
                        if let result = viewModel.result {
                            BuyAdvisorResultStep(result: result) { viewModel.reset() }
                        } else {
                            BuyAdvisorInputStep(viewModel: viewModel)
                        }
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", action: { dismiss() })
                }
            }
        }
    }
}

#Preview {
    BuyAdvisorModal()
}
