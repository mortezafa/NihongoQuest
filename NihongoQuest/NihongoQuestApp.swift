// NihongoQuestApp.swift

import SwiftUI

@main
struct NihongoQuestApp: App {

    @State private var assistantFlowModel = AssistantFlowModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        ImmersiveSpace(id: "chatView") {
            AssistantView()
                .environment(assistantFlowModel)
        }
    }
}
