import Foundation

final class BuyAdvisorService {
    private let apiClient: APIClient
    private let useMockData: Bool

    init(apiClient: APIClient = APIClient(), useMockData: Bool = false) {
        self.apiClient = apiClient
        self.useMockData = useMockData
    }

    func analyze(_ request: BuyAdvisorRequest) async throws -> BuyAdvisorResponse {
        if useMockData { return MockSeed.buyAdvisorSampleResponse }
        return try await apiClient.request(Endpoint.post("/api/buy-advisor/analyze"), body: request)
    }
}
