// AssistantView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct AssistantView: View {
    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.70, -0.35, -1]
        let radians = -30 * Float.pi / 180 // converting -30 degrees to rads here
        rotateEnityAboutY(entity: headAnchor, angle: radians)
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

    static func rotateEnityAboutY(entity: Entity, angle: Float) {
        var currentTransform = entity.transform

        let rotation = simd_quatf(angle: angle, axis: [0,1,0])

        currentTransform.rotation =  rotation * currentTransform.rotation

        entity.transform = currentTransform
    }
}

#Preview {
    AssistantView()
}
