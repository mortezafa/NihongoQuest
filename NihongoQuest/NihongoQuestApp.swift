// NihongoQuestApp.swift

import SwiftUI

@main
struct NihongoQuestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        ImmersiveSpace(id: "chatView") {
            AssistantView()
        }
    }
}
