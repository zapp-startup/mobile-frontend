import Foundation

@MainActor
final class TargetsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var targets: [Target] = []
    @Published var successMessage: String?

    private let service: CirclesService

    init(service: CirclesService = CirclesService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            targets = try await service.fetchTargets()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func createSampleTarget() async {
        do {
            let target = try await service.createTarget(title: "New Monthly Target", targetValue: 500, unit: "USD")
            targets.insert(target, at: 0)
            successMessage = "Target created."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func incrementProgress(for target: Target) async {
        do {
            let updated = try await service.updateTargetProgress(targetID: target.id, currentValue: target.currentValue + max(target.targetValue * 0.1, 1))
            if let index = targets.firstIndex(where: { $0.id == target.id }) {
                targets[index] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
