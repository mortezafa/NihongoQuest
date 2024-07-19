// ContentView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        VStack {
            Text("NihongoQuest")
                .font(.largeTitle)
                .italic()
            HStack {
                Button {
                    // Do something
                } label: {
                    Text("Start")
                }

                Button {
                    // Do something
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
