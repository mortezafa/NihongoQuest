// AssistantView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct AssistantView: View {
    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.70, -0.35, -1]
        let radians = -30 * Float.pi / 180 // converting -30 degrees to rads here
        AssistantView.rotateEnityAboutY(entity: headAnchor, angle: radians)
        return headAnchor

    }()

    @State var showTextField = true

    var body: some View {
        RealityView { content, attachments  in

            do {
                let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)


                guard let attachmentEntity = attachments.entity(for: "helperText") else { return }
                attachmentEntity.position = SIMD3<Float>(0,0.62,0)
                let radians = 30 * Float.pi / 180
                AssistantView.rotateEnityAboutY(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)

            } catch {
                print("Entity load error \(error)")
            }
        } attachments: {
            Attachment(id: "helperText") {
                VStack {
                    Text("meow")
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
                }
                .opacity(showTextField ? 1 : 0)
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
