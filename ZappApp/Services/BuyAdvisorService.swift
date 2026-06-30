import Foundation

final class BuyAdvisorService {
    private let apiClient: APIClient?
    private let useMockData: Bool

    init(apiClient: APIClient? = nil, useMockData: Bool = true) {
        self.apiClient = apiClient
        self.useMockData = useMockData
    }

    func analyze(_ request: BuyAdvisorRequest) async throws -> BuyAdvisorResponse {
        if useMockData { return MockSeed.buyAdvisorSampleResponse }
        guard let apiClient else { throw APIError.unknown }
        return try await apiClient.request(Endpoint(path: "buy-advisor/analyze", method: .post), body: request)
    }
}
