import Foundation

final class AssistantService {
    private let apiClient: APIClient
    private var conversationID: String?

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchMessages() async throws -> [AssistantMessage] {
        let conversationID = try await resolveConversationID(createIfMissing: true)
        return try await listMessages(conversationID: conversationID)
    }

    func sendMessage(_ text: String) async throws -> AssistantMessage {
        let response = try await sendConversationMessage(text: text, actionPayload: nil)
        return response.assistantMessage.toAssistantMessage()
    }

    func startNewChat() async throws -> [AssistantMessage] {
        conversationID = nil
        let conversationID = try await resolveConversationID(createIfMissing: true, forceNewConversation: true)
        return try await listMessages(conversationID: conversationID)
    }

    func streamMessage(_ text: String) async throws -> AssistantMessage {
        let response = try await sendConversationMessage(text: text, actionPayload: nil)
        var message = response.assistantMessage.toAssistantMessage()
        if message.content.contains("LLM not connected yet") {
            message.content = "Your message has been stored."
        }
        return message
    }

    func sendQuickAction(prompt: String, actionPayload: [String: String]) async throws -> AssistantMessage {
        let response = try await sendConversationMessage(text: prompt, actionPayload: actionPayload)
        return response.assistantMessage.toAssistantMessage()
    }

    private func sendConversationMessage(
        text: String,
        actionPayload: [String: String]?
    ) async throws -> ConversationTurnResponse {
        do {
            let conversationID = try await resolveConversationID(createIfMissing: true)
            return try await apiClient.request(
                Endpoint.post("/api/ai/conversations/\(conversationID)/messages/"),
                body: ConversationMessageRequest(content: text, actionPayload: actionPayload)
            )
        } catch APIError.server(let statusCode, _, _) where statusCode == 404 {
            // Frontend parity: recreate conversation and retry when backend no longer recognizes conversation id.
            let conversationID = try await resolveConversationID(createIfMissing: true, forceNewConversation: true)
            return try await apiClient.request(
                Endpoint.post("/api/ai/conversations/\(conversationID)/messages/"),
                body: ConversationMessageRequest(content: text, actionPayload: actionPayload)
            )
        }
    }

    private func listMessages(conversationID: String) async throws -> [AssistantMessage] {
        let payload: [ConversationMessageResponse] = try await apiClient.request(
            Endpoint.get("/api/ai/conversations/\(conversationID)/messages/")
        )
        return payload.map { $0.toAssistantMessage() }
    }

    private func resolveConversationID(
        createIfMissing: Bool,
        forceNewConversation: Bool = false
    ) async throws -> String {
        if !forceNewConversation, let conversationID {
            return conversationID
        }
        if !createIfMissing {
            throw APIError.server(statusCode: 404, message: "No active conversation.")
        }

        let conversation: ConversationResponse = try await apiClient.request(
            Endpoint.post("/api/ai/conversations/"),
            body: EmptyPayload()
        )
        let resolved = conversation.id.stringValue
        self.conversationID = resolved
        return resolved
    }
}

private struct EmptyPayload: Encodable {}

private struct ConversationResponse: Decodable {
    let id: FlexibleIdentifier
}

private struct ConversationMessageRequest: Encodable {
    let content: String
    let actionPayload: [String: String]?
}

private struct ConversationTurnResponse: Decodable {
    let userMessage: ConversationMessageResponse
    let assistantMessage: ConversationMessageResponse
}

private struct ConversationMessageResponse: Decodable {
    let id: FlexibleIdentifier
    let role: String?
    let content: String?
    let createdAt: String?
    let metadataJSON: [String: JSONValue]?

    func toAssistantMessage() -> AssistantMessage {
        let role = AssistantRole(rawValue: role ?? "") ?? .assistant
        let quickActions = parseQuickActions(from: metadataJSON)
        return AssistantMessage(
            id: stableAssistantUUID("msg-\(id.stringValue)"),
            backendID: id.stringValue,
            role: role,
            content: content ?? "",
            createdAt: createdAt ?? ISO8601DateFormatter().string(from: Date()),
            quickActions: quickActions
        )
    }

    private func parseQuickActions(from metadata: [String: JSONValue]?) -> [QuickAction] {
        guard let metadata,
              case let .array(rawActions)? = metadata["quick_actions"] else {
            return []
        }
        return rawActions.compactMap { item in
            guard case let .object(object) = item else { return nil }
            let title: String
            if case let .string(value)? = object["title"] {
                title = value
            } else {
                title = "Open"
            }

            let prompt: String
            if case let .string(value)? = object["prompt"] {
                prompt = value
            } else if case let .string(value)? = object["route"] {
                prompt = value
            } else {
                prompt = title
            }

            let backendID: String?
            if case let .string(value)? = object["id"] {
                backendID = value
            } else {
                backendID = nil
            }

            return QuickAction(
                id: stableAssistantUUID("action-\(backendID ?? prompt)"),
                backendID: backendID,
                title: title,
                prompt: prompt
            )
        }
    }
}

private enum JSONValue: Decodable {
    case string(String)
    case number(Double)
    case int(Int)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON type")
        }
    }
}

private func stableAssistantUUID(_ input: String) -> UUID {
    var hash: UInt64 = 1469598103934665603
    for byte in input.utf8 {
        hash = (hash ^ UInt64(byte)) &* 1099511628211
    }
    let hex = String(format: "%016llx%016llx", hash, hash ^ 0xa0761d6478bd642f)
    let formatted = "\(hex.prefix(8))-\(hex.dropFirst(8).prefix(4))-\(hex.dropFirst(12).prefix(4))-\(hex.dropFirst(16).prefix(4))-\(hex.dropFirst(20).prefix(12))"
    return UUID(uuidString: formatted) ?? UUID()
}
