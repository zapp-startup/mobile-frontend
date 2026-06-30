import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case unauthorized
    case forbidden(message: String?)
    case csrfRequired(message: String?)
    case server(statusCode: Int, message: String?, code: String? = nil)
    case invalidResponse(statusCode: Int)
    case decoding(Error)
    case encoding(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid API URL."
        case .transport(let error): return error.localizedDescription
        case .unauthorized: return "Unauthorized request."
        case .forbidden(let message):
            return message ?? "You do not have permission to perform this action."
        case .csrfRequired(let message):
            return message ?? "Security validation failed. Please try again."
        case .server(let statusCode, let message, _):
            return "Server error (\(statusCode)): \(message ?? "Unknown")"
        case .invalidResponse(let statusCode):
            return "Unexpected server response (\(statusCode))."
        case .decoding(let error): return "Failed to decode response: \(error.localizedDescription)"
        case .encoding(let error): return "Failed to encode payload: \(error.localizedDescription)"
        case .unknown: return "Unknown API error."
        }
    }
}

extension APIError {
    static func fromHTTPStatus(_ statusCode: Int, data: Data) -> APIError {
        let envelope = ErrorEnvelope.decode(from: data)
        let message = envelope.message
        let code = envelope.code

        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden(message: message)
        case 419:
            return .csrfRequired(message: message)
        case 428:
            return .server(statusCode: statusCode, message: message, code: code)
        default:
            if let code, code.lowercased().contains("csrf") {
                return .csrfRequired(message: message)
            }
            return .server(statusCode: statusCode, message: message, code: code)
        }
    }
}

private struct ErrorEnvelope: Decodable {
    let message: String?
    let code: String?

    private struct DetailObject: Decodable {
        let message: String?
        let code: String?
    }

    private struct ErrorCodeEnvelope: Decodable {
        let detail: String?
        let errorCode: String?

        enum CodingKeys: String, CodingKey {
            case detail
            case errorCode = "error_code"
        }
    }

    private struct ErrorStringEnvelope: Decodable {
        let error: String?
    }

    private struct DetailObjectEnvelope: Decodable {
        let detail: DetailObject?
        let errorCode: String?

        enum CodingKeys: String, CodingKey {
            case detail
            case errorCode = "error_code"
        }
    }

    static func decode(from data: Data) -> ErrorEnvelope {
        guard !data.isEmpty else {
            return ErrorEnvelope(message: nil, code: nil)
        }

        let decoder = JSONDecoder()

        if let payload = try? decoder.decode(ErrorCodeEnvelope.self, from: data) {
            return ErrorEnvelope(message: payload.detail, code: payload.errorCode)
        }

        if let payload = try? decoder.decode(ErrorStringEnvelope.self, from: data) {
            return ErrorEnvelope(message: payload.error, code: nil)
        }

        if let payload = try? decoder.decode(DetailObjectEnvelope.self, from: data) {
            return ErrorEnvelope(
                message: payload.detail?.message,
                code: payload.detail?.code ?? payload.errorCode
            )
        }

        if let dictionary = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], !dictionary.isEmpty {
            let message = dictionary
                .compactMap { key, value -> String? in
                    if key == "detail", let text = value as? String {
                        return text
                    }
                    if key == "error", let text = value as? String {
                        return text
                    }
                    if let values = value as? [String], !values.isEmpty {
                        return "\(key): \(values.joined(separator: ", "))"
                    }
                    return nil
                }
                .first
            let code = (dictionary["error_code"] as? String) ?? (dictionary["code"] as? String)
            return ErrorEnvelope(message: message, code: code)
        }

        if let plainText = String(data: data, encoding: .utf8), !plainText.isEmpty {
            return ErrorEnvelope(message: plainText, code: nil)
        }

        return ErrorEnvelope(message: nil, code: nil)
    }
}
