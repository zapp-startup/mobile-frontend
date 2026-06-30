import Foundation

@MainActor
final class CirclesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var circles: [Circle] = []
    @Published var showCreateModal = false
    @Published var showJoinModal = false

    private let service: CirclesService

    init(service: CirclesService = CirclesService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            circles = try await service.fetchCircles()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func create(name: String, isPrivate: Bool) async {
        do {
            let circle = try await service.createCircle(name: name, isPrivate: isPrivate)
            circles.insert(circle, at: 0)
            successMessage = "Circle created."
            showCreateModal = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func join(inviteCode: String) async {
        do {
            let circle = try await service.joinCircle(inviteCode: inviteCode)
            if !circles.contains(where: { $0.id == circle.id }) {
                circles.append(circle)
            }
            successMessage = "Joined circle."
            showJoinModal = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func leave(circleId: UUID) async {
        do {
            try await service.leaveCircle(circleId: circleId)
            circles.removeAll { $0.id == circleId }
            successMessage = "Left circle."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
