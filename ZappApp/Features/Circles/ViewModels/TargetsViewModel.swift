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

    func createTarget(title: String, targetValue: Double, unit: String = "USD") async {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Target title cannot be empty."
            return
        }
        guard targetValue > 0 else {
            errorMessage = "Target amount must be greater than zero."
            return
        }
        do {
            let target = try await service.createTarget(title: trimmedTitle, targetValue: targetValue, unit: unit)
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
