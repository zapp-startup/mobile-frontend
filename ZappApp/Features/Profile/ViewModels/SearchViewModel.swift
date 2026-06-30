import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""

    let suggestions = [
        "Find high-value subscriptions",
        "Show transactions tagged food",
        "Search privacy settings",
        "Review my weekly spending"
    ]

    var filteredSuggestions: [String] {
        guard !query.isEmpty else { return suggestions }
        return suggestions.filter { $0.localizedCaseInsensitiveContains(query) }
    }
}
