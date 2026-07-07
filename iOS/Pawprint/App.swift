import SwiftUI

@main
struct PawprintApp: App {
    @StateObject private var store = PawprintStore()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .tint(Theme.accent)
        }
    }
}
