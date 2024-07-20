// AssistantView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct AssistantView: View {
    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.70, -0.35, -1]
        return headAnchor

    }()

    var body: some View {
        RealityView { content in

            do {
                let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)
            } catch {
                print("Entity load error \(error)")
            }
        }
    }

    
}

#Preview {
    AssistantView()
}
