// AssistantView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct AssistantView: View {
    @State private var assistant: Entity? = nil

    
    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.55, -0.35, -1]
        let radians = -30 * Float.pi / 180 // converting -30 degrees to rads here
        AssistantView.rotateEnityAboutY(entity: headAnchor, angle: radians)
        return headAnchor

    }()

    @State var showTextField = false
    @State private var chatText = "Tap me to start!"
    @State private var assistant: Entity? = nil



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
                    Text(chatText)
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
                }
                //                .opacity(showTextField ? 1 : 0)
            }
        }
        .onTapGesture {
            assistantModel.assistantState = .speaking
        }
        .onChange(of: assistantModel.assistantState) { _, newValue in
            switch newValue {
            case .idle:
                break
            case .speaking:
                playIntro()
            @unknown default:
                break
            }
        }
    }

        func animatePromptText(text: String) async {
            // Type out the title.
            chatText = ""
            let words = text.split(separator: " ")
            for word in words {
                chatText.append(word + " ")
                let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 100
                try? await Task.sleep(for: .milliseconds(milliseconds))
            }
        }

        func playIntro() {
            Task {
                let texts = [
                    "Hey welcome to NihongoQuest!\nMy name is Yaobten nice to meet you!"
                ]


                await animatePromptText(text: texts[0])
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
