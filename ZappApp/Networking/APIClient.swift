import Foundation

final class APIClient {
    private static let fallbackBaseURL = URL(string: "http://localhost:8000")!

    static var configuredBaseURL: URL {
        let environment = ProcessInfo.processInfo.environment
        if let configured = environment["ZAPP_API_BASE_URL"]?.trimmingCharacters(in: .whitespacesAndNewlines),
           !configured.isEmpty,
           let url = URL(string: configured) {
            return url
        }
        return fallbackBaseURL
    }

    private let baseURL: URL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private let cookieStorage: HTTPCookieStorage
    private let csrfCookieName: String
    private let csrfHeaderName: String

    init(
        baseURL: URL = APIClient.configuredBaseURL,
        session: URLSession? = nil,
        cookieStorage: HTTPCookieStorage = .shared,
        csrfCookieName: String = "csrftoken",
        csrfHeaderName: String = "X-CSRFToken"
    ) {
        self.baseURL = baseURL
        self.cookieStorage = cookieStorage
        self.csrfCookieName = csrfCookieName
        self.csrfHeaderName = csrfHeaderName

        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.httpCookieStorage = cookieStorage
            configuration.httpShouldSetCookies = true
            configuration.httpCookieAcceptPolicy = .always
            self.session = URLSession(configuration: configuration)
        }

        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    private func buildRequest<Body: Encodable>(
        endpoint: Endpoint,
        authToken: String?,
        body: Body?,
        csrfToken: String?
    ) throws -> URLRequest {
        guard var components = URLComponents(url: url(for: endpoint), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        if let authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        if let csrfToken, endpoint.shouldAttachCSRF {
            request.setValue(csrfToken, forHTTPHeaderField: csrfHeaderName)
        }
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.encoding(error)
            }
        }
        return request
    }

    private func execute<Response: Decodable>(request: URLRequest) async throws -> Response {
        do {
            debugCookieSnapshot(for: request, message: "Before request")
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            switch httpResponse.statusCode {
            case 200...299:
                if Response.self == EmptyResponse.self, data.isEmpty {
                    return EmptyResponse() as! Response
                }
                if data.isEmpty {
                    debugLog(
                        request: request,
                        statusCode: httpResponse.statusCode,
                        expectedType: Response.self,
                        data: data,
                        message: "Received empty body for non-empty response type."
                    )
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
                do {
                    return try decoder.decode(Response.self, from: data)
                } catch {
                    debugLog(
                        request: request,
                        statusCode: httpResponse.statusCode,
                        expectedType: Response.self,
                        data: data,
                        message: "Decoding failure: \(error.localizedDescription)"
                    )
                    throw APIError.decoding(error)
                }
            default:
                debugLog(
                    request: request,
                    statusCode: httpResponse.statusCode,
                    expectedType: Response.self,
                    data: data,
                    message: "Non-2xx response"
                )
                throw APIError.fromHTTPStatus(httpResponse.statusCode, data: data)
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.transport(error)
        }
    }

    private func url(for endpoint: Endpoint) -> URL {
        if let absolute = URL(string: endpoint.path), absolute.scheme != nil {
            return absolute
        }
        let relativePath = endpoint.normalizedPath.hasPrefix("/") ? String(endpoint.normalizedPath.dropFirst()) : endpoint.normalizedPath
        return baseURL.appendingPathComponent(relativePath)
    }

    private func csrfToken() -> String? {
        let host = baseURL.host
        return cookieStorage.cookies?.first(where: { cookie in
            let domainMatches: Bool
            if let host {
                let cookieDomain = cookie.domain.trimmingCharacters(in: CharacterSet(charactersIn: "."))
                domainMatches = host == cookieDomain || host.hasSuffix(".\(cookieDomain)")
            } else {
                domainMatches = true
            }
            return cookie.name == csrfCookieName && domainMatches
        })?.value
    }

    private func bootstrapCSRFIfNeeded() async throws -> String? {
        if let token = csrfToken() {
            return token
        }

        let csrfEndpoint = Endpoint.get("/api/auth/csrf/")
        let request = try buildRequest(endpoint: csrfEndpoint, authToken: nil, body: Optional<String>.none, csrfToken: nil)
        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.csrfRequired(message: "Unable to establish CSRF session.")
        }
        return csrfToken()
    }

    func request<Response: Decodable, Body: Encodable>(
        _ endpoint: Endpoint,
        authToken: String? = nil,
        body: Body? = nil,
        requiresCSRFBootstrap: Bool = true
    ) async throws -> Response {
        let csrf: String?
        if endpoint.shouldAttachCSRF {
            csrf = try await bootstrapCSRFIfNeeded()
        } else {
            csrf = csrfToken()
        }

        let request = try buildRequest(endpoint: endpoint, authToken: authToken, body: body, csrfToken: csrf)
        do {
            return try await execute(request: request)
        } catch APIError.csrfRequired where requiresCSRFBootstrap && endpoint.shouldAttachCSRF {
            _ = try await bootstrapCSRFIfNeeded()
            let retryToken = csrfToken()
            let retryRequest = try buildRequest(endpoint: endpoint, authToken: authToken, body: body, csrfToken: retryToken)
            return try await execute(request: retryRequest)
        }
    }

    func request<Response: Decodable>(
        _ endpoint: Endpoint,
        authToken: String? = nil
    ) async throws -> Response {
        let request = try buildRequest(endpoint: endpoint, authToken: authToken, body: Optional<String>.none, csrfToken: csrfToken())
        return try await execute(request: request)
    }

    private func debugLog<Response: Decodable>(
        request: URLRequest,
        statusCode: Int,
        expectedType: Response.Type,
        data: Data,
        message: String
    ) {
#if DEBUG
        let body = String(data: data, encoding: .utf8) ?? "<non-utf8-body>"
        let url = request.url?.absoluteString ?? "<unknown-url>"
        print(
            """
            [APIClient Debug] \(message)
            URL: \(url)
            Method: \(request.httpMethod ?? "UNKNOWN")
            Status: \(statusCode)
            Expected: \(String(describing: expectedType))
            Outbound Cookie Header: \(request.value(forHTTPHeaderField: "Cookie") ?? "<none>")
            Body: \(body)
            """
        )
#endif
    }

    private func debugCookieSnapshot(for request: URLRequest, message: String) {
#if DEBUG
        let requestURL = request.url
        let cookieDump: String
        if let requestURL,
           let cookies = cookieStorage.cookies(for: requestURL),
           !cookies.isEmpty {
            cookieDump = cookies.map { "\($0.name)=\($0.value) [domain=\($0.domain)]" }.joined(separator: "; ")
        } else {
            cookieDump = "<no cookies for request URL>"
        }
        print(
            """
            [APIClient Debug] \(message)
            URL: \(requestURL?.absoluteString ?? "<unknown-url>")
            Cookie Storage Snapshot: \(cookieDump)
            """
        )
#endif
    }
}

struct EmptyResponse: Codable {}
