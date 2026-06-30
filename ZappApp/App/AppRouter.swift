import Foundation

enum AppTab: Hashable {
    case home
    case transactions
    case subscriptions
    case circles
    case profile
}

enum TransactionsRoute: Hashable {
    case transactionDetail(String)
    case transactionForm(String?)
    case bankingConnections
    case bankConnectionDetail(String)
    case bankTransactions(String?)
}

enum SubscriptionsRoute: Hashable {
    case subscriptionDetail(UUID)
    case subscriptionForm(UUID?)
    case spotifyCallback
}

enum CirclesRoute: Hashable {
    case circleDetail(UUID)
    case badges
    case targets
    case weeklyReview
    case monthlyReview
}

enum ProfileRoute: Hashable {
    case search
    case privacy
    case analytics
}
