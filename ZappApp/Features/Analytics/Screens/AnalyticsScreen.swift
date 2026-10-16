import SwiftUI

struct AnalyticsScreen: View {
    @StateObject private var viewModel = AnalyticsViewModel()

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Analytics", subtitle: "Valuation and metric intelligence")
                    if viewModel.isLoading && viewModel.metrics.isEmpty {
                        AppLoadingState(title: "Loading analytics", message: "Fetching metric cards and valuation context.")
                    } else if let errorMessage = viewModel.errorMessage, viewModel.metrics.isEmpty {
                        AppErrorState(title: "Analytics Error", message: errorMessage) {
                            Task { await viewModel.load() }
                        }
                    } else {
                        ForEach(viewModel.metrics) { metric in
                            AnalyticsMetricCard(metric: metric)
                        }
                    }

                    ValuationInputCard(
                        description: $viewModel.valuationDescription,
                        amount: $viewModel.valuationAmount,
                        onCompute: { Task { await viewModel.compute() } },
                        isLoading: viewModel.isLoading
                    )

                    MetricDrilldownCard(title: "Computed Outputs", values: viewModel.result?.computedOutputs ?? [:])
                    MetricDrilldownCard(title: "Inferred / Raw Values", values: viewModel.result?.inferredValues ?? [:])
                    MetricDrilldownCard(title: "Value Outputs", values: viewModel.result?.valueOutputs ?? [:])
                    InsightsListSection(insights: viewModel.result?.insights ?? [])

                    if let errorMessage = viewModel.errorMessage, !viewModel.metrics.isEmpty {
                        StatusChip(text: errorMessage, tone: AppColors.error)
                    }
                }
            }
            .task { await viewModel.load() }
        }
    }
}

#Preview {
    NavigationStack {
        AnalyticsScreen()
    }
}
