import Foundation

struct HomeKPI: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: String
    let delta: String
}

struct CategorySpend: Identifiable, Hashable {
    let id = UUID()
    let category: String
    let amount: Double
    let percent: Double
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var payload: DashboardPayload?

    private let dashboardService: DashboardService

    init(dashboardService: DashboardService = DashboardService()) {
        self.dashboardService = dashboardService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            payload = try await dashboardService.fetchDashboard()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var hasData: Bool { payload != nil }
    var recentTransactions: [Transaction] { payload?.recentTransactions ?? [] }
    var metrics: [AnalyticsMetric] { payload?.metrics ?? [] }
    var circles: [Circle] { payload?.circles ?? [] }

    var totalSpent: Double {
        recentTransactions
            .filter { $0.type.isExpense }
            .reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Double {
        recentTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    var valueScoreAverage: Int {
        let scores = recentTransactions.compactMap(\.valueScore)
        guard !scores.isEmpty else { return 0 }
        return scores.reduce(0, +) / scores.count
    }

    var kpis: [HomeKPI] {
        [
            HomeKPI(title: "Streak", value: "\(max(circles.first?.leaderboard.first?.score ?? 0, 7)) pts", delta: "+4%"),
            HomeKPI(title: "Spent", value: currency(totalSpent), delta: "-3%"),
            HomeKPI(title: "Income", value: currency(totalIncome), delta: "+2%")
        ]
    }

    var categoryBreakdown: [CategorySpend] {
        let expenses = recentTransactions.filter { $0.type.isExpense }
        let total = expenses.reduce(0) { $0 + $1.amount }
        guard total > 0 else { return [] }
        let grouped = Dictionary(grouping: expenses, by: \.category)
        return grouped
            .map { key, values in
                let amount = values.reduce(0) { $0 + $1.amount }
                return CategorySpend(category: key, amount: amount, percent: amount / total)
            }
            .sorted { $0.amount > $1.amount }
    }

    var topInsight: String {
        if let topCategory = categoryBreakdown.first {
            return "Your highest spend category is \(topCategory.category). A 10% trim saves \(currency(topCategory.amount * 0.1))/month."
        }
        return "Add transactions to unlock personalized value insights."
    }

    private func currency(_ value: Double) -> String {
        Formatters.currency.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
