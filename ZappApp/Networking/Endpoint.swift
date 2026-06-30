import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"

    var isUnsafe: Bool {
        switch self {
        case .get:
            return false
        case .post, .put, .patch, .delete:
            return true
        }
    }
}

struct Endpoint {
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var requiresCSRF: Bool?

    static func get(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: path, method: .get, queryItems: queryItems)
    }

    static func post(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: path, method: .post, queryItems: queryItems)
    }

    static func put(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: path, method: .put, queryItems: queryItems)
    }

    static func patch(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: path, method: .patch, queryItems: queryItems)
    }

    static func delete(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: path, method: .delete, queryItems: queryItems)
    }

    var normalizedPath: String {
        if path.hasPrefix("/") {
            return path
        }
        return "/\(path)"
    }

    var shouldAttachCSRF: Bool {
        requiresCSRF ?? method.isUnsafe
    }
}
