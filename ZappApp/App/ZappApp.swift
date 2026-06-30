import SwiftUI

@main
struct ZappApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .onOpenURL { url in
                    #if DEBUG
                    print("[OAuth Debug] onOpenURL received: \(url.absoluteString)")
                    #endif
                    if url.scheme == "zapp" && url.host == "auth" {
                        appState.handleOAuthCallback(url)
                    }
                }
        }
    }
}
