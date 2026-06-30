import Foundation

@MainActor
final class BadgesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var badges: [Badge] = []

    private let service: CirclesService

    init(service: CirclesService = CirclesService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            badges = try await service.fetchBadges()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
