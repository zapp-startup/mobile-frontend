import Foundation

struct DashboardPayload: Codable {
    var recentTransactions: [Transaction]
    var metrics: [AnalyticsMetric]
    var circles: [Circle]
}

final class DashboardService {
    private let transactionsService: TransactionsService
    private let analyticsService: AnalyticsService
    private let circlesService: CirclesService

    init(
        transactionsService: TransactionsService = TransactionsService(),
        analyticsService: AnalyticsService = AnalyticsService(),
        circlesService: CirclesService = CirclesService()
    ) {
        self.transactionsService = transactionsService
        self.analyticsService = analyticsService
        self.circlesService = circlesService
    }

    func fetchDashboard() async throws -> DashboardPayload {
        async let recentTransactionsTask = transactionsService.fetchTransactions(limit: 20)
        async let metricsTask = analyticsService.fetchMetrics()
        async let circlesTask = circlesService.fetchCircles()

        let (recentTransactions, metrics, circles) = try await (
            recentTransactionsTask,
            metricsTask,
            circlesTask
        )
        return DashboardPayload(
            recentTransactions: recentTransactions,
            metrics: metrics,
            circles: circles
        )
    }
}
