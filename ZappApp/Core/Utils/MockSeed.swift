import Foundation

enum MockSeed {
    static let isoNow = "2026-04-15T12:00:00Z"

    static let sharedUser = User(
        id: "1",
        fullName: "Avery Johnson",
        email: "avery@zapp.app",
        username: "avery",
        tier: "Gold",
        initials: "AJ",
        mfaEnabled: true,
        createdAt: isoNow
    )

    static let financialProfile = FinancialProfile(
        lifeStage: "Early Career",
        householdSize: 2,
        zipCode: "94107",
        incomeRange: "100k-150k",
        monthlyFixedExpenses: 3400,
        financialGoal: "Build emergency fund",
        riskTolerance: 6,
        budgetStyle: "50/30/20",
        spendingPriorities: ["cost", "quality"],
        researchHabit: "Compare before purchase"
    )

    static let preferences: [Preference] = [
        Preference(id: UUID(), key: "theme", value: "dark", category: "app"),
        Preference(id: UUID(), key: "notifications", value: "enabled", category: "alerts"),
        Preference(id: UUID(), key: "assistantTone", value: "coach", category: "assistant")
    ]

    static let transactions: [Transaction] = [
        Transaction(
            id: "tx-1",
            description: "Coffee and breakfast",
            merchant: "Blue Bottle",
            category: "Food",
            amount: 18.75,
            currency: "USD",
            type: .expense,
            date: "2026-04-13",
            valueScore: 74,
            satisfaction: 8,
            feedback: TransactionFeedback(satisfaction: 8, regretScore: 2, repurchaseLikelihood: 8, usageFrequency: "weekly", reflection: "Good value for quality."),
            source: "manual",
            createdAt: isoNow,
            updatedAt: isoNow,
            backendDirection: "spend",
            paymentChannel: "card"
        ),
        Transaction(
            id: "tx-2",
            description: "Payroll deposit",
            merchant: "Employer Inc.",
            category: "Income",
            amount: 4200,
            currency: "USD",
            type: .income,
            date: "2026-04-12",
            valueScore: nil,
            satisfaction: nil,
            feedback: nil,
            source: "bank",
            createdAt: isoNow,
            updatedAt: isoNow,
            backendDirection: "income",
            paymentChannel: nil
        )
    ]

    static let subscriptions: [Subscription] = [
        Subscription(
            id: UUID(),
            backendID: nil,
            merchant: "Spotify",
            amount: 10.99,
            currency: "USD",
            billingCycle: .monthly,
            status: .active,
            startedAt: "2025-08-01",
            notes: "Family account candidate",
            valuation: SubscriptionValuation(valueScore: 81, explanation: "High weekly usage offsets cost.", confidence: 0.89)
        ),
        Subscription(
            id: UUID(),
            backendID: nil,
            merchant: "Notion",
            amount: 8.00,
            currency: "USD",
            billingCycle: .monthly,
            status: .active,
            startedAt: "2025-01-15",
            notes: "Shared workspace",
            valuation: SubscriptionValuation(valueScore: 76, explanation: "Consistent productivity utility.", confidence: 0.77)
        )
    ]

    static let spotifyConnection = SpotifyConnection(
        id: UUID(),
        status: .connected,
        accountName: "avery.j",
        product: "Premium",
        lastSyncedAt: isoNow,
        statusMessage: "Connected and healthy."
    )

    static let circles: [Circle] = [
        Circle(
            id: UUID(),
            backendID: nil,
            name: "No-Spend Week",
            privacy: .private,
            inviteCode: "ZAPP77",
            memberCount: 4,
            members: [
                CircleMember(id: UUID(), displayName: "Avery", rank: 1, points: 120, isCurrentUser: true),
                CircleMember(id: UUID(), displayName: "Mina", rank: 2, points: 110, isCurrentUser: false)
            ],
            leaderboard: [
                CircleLeaderboardEntry(id: UUID(), memberName: "Avery", rank: 1, score: 120),
                CircleLeaderboardEntry(id: UUID(), memberName: "Mina", rank: 2, score: 110)
            ]
        )
    ]

    static let badges: [Badge] = [
        Badge(id: UUID(), title: "Saver Streak", description: "Saved 4 weeks in a row", iconName: "flame.fill", unlockedAt: "2026-04-10"),
        Badge(id: UUID(), title: "Insight Hunter", description: "Used 10 recommendations", iconName: "star.fill", unlockedAt: nil)
    ]

    static let targets: [Target] = [
        Target(id: UUID(), backendID: nil, title: "Emergency Fund", type: "Savings", targetValue: 10000, currentValue: 4300, unit: "USD", status: .active),
        Target(id: UUID(), backendID: nil, title: "Dining Out", type: "Budget", targetValue: 250, currentValue: 190, unit: "USD", status: .active)
    ]

    static let weeklyReview = Review(
        id: UUID(),
        period: .weekly,
        reviewedCount: 12,
        pendingCount: 3,
        prompts: [
            ReviewPrompt(id: UUID(), question: "Which purchases felt most valuable?", answer: nil),
            ReviewPrompt(id: UUID(), question: "What would you skip next week?", answer: nil)
        ],
        reflections: [],
        submittedAt: nil
    )

    static let monthlyReview = Review(
        id: UUID(),
        period: .monthly,
        reviewedCount: 48,
        pendingCount: 5,
        prompts: [
            ReviewPrompt(id: UUID(), question: "Did spending align with goals?", answer: nil),
            ReviewPrompt(id: UUID(), question: "Top category to optimize next month?", answer: nil)
        ],
        reflections: [],
        submittedAt: nil
    )

    static let analyticsMetrics: [AnalyticsMetric] = [
        AnalyticsMetric(id: UUID(), title: "Tracked Stacks", value: "12", delta: "+2"),
        AnalyticsMetric(id: UUID(), title: "Highest Overlap", value: "Subscriptions", delta: "-3%"),
        AnalyticsMetric(id: UUID(), title: "Watchlist", value: "5", delta: "+1")
    ]

    static let valuationResult = ValuationResult(
        computedOutputs: ["expectedValue": 132.5, "riskAdjustedValue": 109.2],
        inferredValues: ["confidenceScore": 0.84, "utilityIndex": 0.71],
        valueOutputs: ["recommendationScore": 78],
        insights: ["Price is below projected utility threshold.", "Category spend still under monthly cap."]
    )

    static let assistantMessages: [AssistantMessage] = [
        AssistantMessage(
            id: UUID(),
            role: .assistant,
            content: "Hi Avery - want to review your latest spending trends?",
            createdAt: isoNow,
            quickActions: [
                QuickAction(id: UUID(), title: "Show weekly spend", prompt: "Show my weekly spend summary"),
                QuickAction(id: UUID(), title: "Find savings", prompt: "Where can I save this week?")
            ]
        )
    ]

    static let bankConnections: [BankConnection] = [
        BankConnection(
            id: "101",
            institutionName: "Chase",
            institutionId: "ins_123",
            status: .active,
            lastSyncedAt: isoNow,
            canSync: true,
            requiresConsent: false,
            requiresMFA: false
        )
    ]

    static let bankAccounts: [BankAccount] = {
        guard let connection = bankConnections.first else { return [] }
        return [
            BankAccount(id: "201", connectionId: connection.id, name: "Everyday Checking", type: "checking", mask: "1234", balance: 5220.31, currency: "USD"),
            BankAccount(id: "202", connectionId: connection.id, name: "Travel Savings", type: "savings", mask: "8732", balance: 11820.00, currency: "USD")
        ]
    }()

    static let bankTransactions: [BankTransaction] = {
        guard let connection = bankConnections.first, let account = bankAccounts.first else { return [] }
        return [
            BankTransaction(
                id: "301",
                connectionId: connection.id,
                accountId: account.id,
                merchant: "Trader Joe's",
                description: "Groceries",
                category: "Food",
                amount: 63.20,
                currency: "USD",
                direction: .expense,
                date: "2026-04-11",
                valueScore: 73,
                removed: false
            )
        ]
    }()

    static let buyAdvisorSampleRequest = BuyAdvisorRequest(predictedPrice: 199, category: "Electronics")
    static let buyAdvisorSampleResponse = BuyAdvisorResponse(
        recommendation: "Wait",
        valueScore: 64,
        rationale: "Price trend suggests lower entry point within 3 weeks.",
        confidence: 0.82
    )
}
