import XCTest
@testable import ZappApp

/// Proves the offline test harness works end-to-end: APIClient -> URLProtocol stub -> decode.
/// Later per-service tests reuse URLProtocolStub the same way.
final class APIClientSmokeTests: XCTestCase {
    private struct Ping: Decodable, Equatable {
        let ok: Bool
        let itemCount: Int   // exercises snake_case ("item_count") decoding
    }

    func testDecodesGetResponse() async throws {
        URLProtocolStub.stub(json: #"{"ok": true, "item_count": 3}"#)
        let client = URLProtocolStub.makeClient()
        let ping: Ping = try await client.request(Endpoint.get("/ping/"))
        XCTAssertEqual(ping, Ping(ok: true, itemCount: 3))
    }

    func testNon2xxThrows() async {
        URLProtocolStub.stub(json: #"{"detail": "nope"}"#, status: 500)
        let client = URLProtocolStub.makeClient()
        do {
            let _: Ping = try await client.request(Endpoint.get("/ping/"))
            XCTFail("Expected an error for a 500 response")
        } catch {
            // expected
        }
    }
}
