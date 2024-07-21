// ContentView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var closeImmersiveSpace
    var body: some View {
        VStack {
            Text("NihongoQuest")
                .font(.largeTitle)
                .italic()
            HStack {
                Button {
                    Task {
                        await openImmersiveSpace(id: "chatView")
                    }
                } label: {
                    Text("Start")
                }

                Button {
                    Task {
                         await closeImmersiveSpace()
                    }
                } label: {
                    Text("Learn More")
                }
            }
            .padding()

        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
