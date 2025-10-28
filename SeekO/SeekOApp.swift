import SwiftUI

@main
struct SeekOApp: App {
    @StateObject private var gameManager = GameManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(gameManager)
        }
    }
}
