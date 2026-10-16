import Foundation

enum BuyAdvisorStep {
    case input
    case loading
    case result
}

@MainActor
final class BuyAdvisorViewModel: ObservableObject {
    @Published var step: BuyAdvisorStep = .input
    @Published var predictedPrice = ""
    @Published var category = ""
    @Published var errorMessage: String?
    @Published var result: BuyAdvisorResponse?

    private let service: BuyAdvisorService

    init(service: BuyAdvisorService = BuyAdvisorService()) {
        self.service = service
    }

    func analyze() async {
        guard let price = Double(predictedPrice), price > 0, !category.isEmpty else {
            errorMessage = "A positive price and a category are required."
            return
        }
        errorMessage = nil
        step = .loading
        do {
            result = try await service.analyze(BuyAdvisorRequest(predictedPrice: price, category: category))
            step = .result
        } catch {
            errorMessage = error.localizedDescription
            step = .input
        }
    }

    func reset() {
        step = .input
        result = nil
        errorMessage = nil
    }
}
