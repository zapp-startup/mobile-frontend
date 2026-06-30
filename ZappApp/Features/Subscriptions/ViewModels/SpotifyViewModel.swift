import Foundation
import UIKit

@MainActor
final class SpotifyViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var connection: SpotifyConnection?
    @Published var insights: SpotifyInsights?

    private let service: SpotifyService

    init(service: SpotifyService = SpotifyService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            connection = try await service.fetchConnectionStatus()
            insights = try? await service.fetchInsights()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func connect() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let authURL = try await service.connect()
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
            successMessage = "Spotify authorization started."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func sync() async {
        isLoading = true
        defer { isLoading = false }
        do {
            connection = try await service.sync()
            insights = try? await service.fetchInsights()
            successMessage = "Spotify sync triggered."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func disconnect() async {
        isLoading = true
        defer { isLoading = false }
        do {
            connection = try await service.disconnect()
            insights = nil
            successMessage = "Spotify disconnected."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resolveCallback() async {
        isLoading = true
        defer { isLoading = false }
        do {
            connection = try await service.resolveCallbackAndRefresh()
            insights = try? await service.fetchInsights()
            successMessage = "Spotify callback completed."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
