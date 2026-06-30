import Foundation

@MainActor
final class CircleDetailViewModel: ObservableObject {
    @Published var circle: Circle?
    @Published var errorMessage: String?

    func bind(circleId: UUID, source: [Circle]) {
        circle = source.first(where: { $0.id == circleId })
        if circle == nil { errorMessage = "Circle not found." }
    }
}
