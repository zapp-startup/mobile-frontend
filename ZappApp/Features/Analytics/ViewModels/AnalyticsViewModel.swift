import Foundation

@MainActor
final class AnalyticsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var metrics: [AnalyticsMetric] = []
    @Published var valuationDescription = ""
    @Published var valuationAmount = ""
    @Published var result: ValuationResult?

    private let service: AnalyticsService

    init(service: AnalyticsService = AnalyticsService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            metrics = try await service.fetchMetrics()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func compute() async {
        guard let amount = Double(valuationAmount), !valuationDescription.isEmpty else {
            errorMessage = "Enter a valuation description and amount."
            return
        }
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            result = try await service.computeValuation(input: ValuationInput(description: valuationDescription, amount: amount))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
