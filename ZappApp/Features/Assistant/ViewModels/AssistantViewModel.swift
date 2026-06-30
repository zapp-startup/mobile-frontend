import Foundation

@MainActor
final class AssistantViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isTyping = false
    @Published var errorMessage: String?
    @Published var draftMessage = ""
    @Published var messages: [AssistantMessage] = []

    private let service: AssistantService
    private let isoFormatter = ISO8601DateFormatter()

    init(service: AssistantService = AssistantService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            messages = try await service.fetchMessages()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func newChat() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            messages = try await service.startNewChat()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func sendDraft() async {
        let text = draftMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        draftMessage = ""
        let userMessage = AssistantMessage(id: UUID(), role: .user, content: text, createdAt: isoFormatter.string(from: Date()), quickActions: [])
        messages.append(userMessage)
        await send(text: text)
    }

    func sendQuickAction(_ action: QuickAction) async {
        let userMessage = AssistantMessage(id: UUID(), role: .user, content: action.prompt, createdAt: isoFormatter.string(from: Date()), quickActions: [])
        messages.append(userMessage)
        await send(text: action.prompt, actionPayload: ["title": action.title, "prompt": action.prompt])
    }

    private func send(text: String, actionPayload: [String: String]? = nil) async {
        isTyping = true
        defer { isTyping = false }
        do {
            let response: AssistantMessage
            if let actionPayload {
                response = try await service.sendQuickAction(prompt: text, actionPayload: actionPayload)
            } else {
                response = try await service.streamMessage(text)
            }
            messages.append(response)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
