import Foundation
@testable import ZappApp

/// Test-only URLProtocol that returns canned responses so services can be tested
/// with zero backend. Set `responseData` / `statusCode` before the request.
final class URLProtocolStub: URLProtocol {
    static var responseData = Data()
    static var statusCode = 200
    static var headers: [String: String] = ["Content-Type": "application/json"]

    static func stub(json: String, status: Int = 200) {
        responseData = Data(json.utf8)
        statusCode = status
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url ?? URL(string: "http://stub.local")!,
            statusCode: Self.statusCode,
            httpVersion: nil,
            headerFields: Self.headers
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.responseData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    /// APIClient wired to the stub instead of a real network.
    static func makeClient() -> APIClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return APIClient(session: URLSession(configuration: config))
    }
}
