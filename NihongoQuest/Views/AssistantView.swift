// AssistantView.swift

import SwiftUI
import RealityKit
import RealityKitContent
import Combine
struct AssistantView: View {
    @Environment(AssistantFlowModel.self) private var assistantModel

    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.45, -0.35, -1]
        let radians = -30 * Float.pi / 180 // converting -30 degrees to rads here
        AssistantView.rotateEnityAboutY(entity: headAnchor, angle: radians)
        return headAnchor

    }()

    @State private var chatText = "Tap me to start!"
    @State private var assistant: Entity? = nil
    @State private var waveAnimation: AnimationResource? = nil
    @State private var currentDialogueIndex = 0
    @State private var isAnimating = false
    let dialogues = [
        "Hey welcome to NihongoQuest!\nMy name is Yaobten nice to meet you!",
        "Let's learn Japanese together!",
        "This app is disigned to mimic comprehensible input in japanese",
        "once your ready tap the 'Lets go' button to head to the first level!",
    ]
    @State public var showAttachmentButtons = false




    var body: some View {
        RealityView { content, attachments  in

            do {
                let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)


                guard let attachmentEntity = attachments.entity(for: "helperText") else { return }
                attachmentEntity.position = SIMD3<Float>(0,0.62,0)
                let radians = 15 * Float.pi / 180
                AssistantView.rotateEnityAboutY(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)


                let characterAnimationSceneEntity = try await Entity(named: "CharacterAnimations", in: realityKitContentBundle)
                guard let waveModel = characterAnimationSceneEntity.findEntity(named: "wave_model") else { return }

                guard let assistant = characterEntity.findEntity(named: "assistant") else { return }
                guard let idleAnimationResource = assistant.availableAnimations.first else { return }
                guard let waveAnimationResource = waveModel.availableAnimations.first else { return }
                let waveAnimation = try AnimationResource.sequence(with: [waveAnimationResource, idleAnimationResource.repeat()])

                Task {
                    self.assistant = assistant
                    self.waveAnimation = waveAnimation
                }

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
                    if showAttachmentButtons {
                        HStack(spacing: 20) {
                            Button(action: {
                                tapSubject.send()
                            }) {
                                Text("Yes, let's go!")
                                    .font(.largeTitle)
                                    .fontWeight(.regular)
                                    .padding()
                                    .cornerRadius(8)
                            }
                            .padding()
                            .buttonStyle(.bordered)

                            Button(action: {
                                // Action for No button
                            }) {
                                Text("No")
                                    .font(.largeTitle)
                                    .fontWeight(.regular)
                                    .padding()
                                    .cornerRadius(8)
                            }
                            .padding()
                            .buttonStyle(.bordered)
                        }
                        .glassBackgroundEffect()
                        .opacity(showAttachmentButtons ? 1 : 0)
                    }
                }
            }
        }

        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded {_ in 
            assistantModel.assistantState = .speaking
            guard !isAnimating else { return }
            advanceDialogue()
        })
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
            if let assistant = self.assistant, let waveAnimation = self.waveAnimation {
                await assistant.playAnimation(waveAnimation.repeat(count: 1))
            }
        }
    }

    func advanceDialogue() {
        if currentDialogueIndex < dialogues.count {
            showAttachmentButtons = false
            playDialogue(text: dialogues[currentDialogueIndex])
            currentDialogueIndex += 1
        } else {
            currentDialogueIndex = 0

            Task {
                await waitForButtonTap(using: tapSubject)
            }

        }
    }

    func playDialogue(text: String) {
        Task {
            isAnimating = true
            await animatePromptText(text: text)
            if currentDialogueIndex == dialogues.count {
                withAnimation(.easeInOut) {
                    showAttachmentButtons = true
                }
            }
            isAnimating = false
        }
    }


    let tapSubject = PassthroughSubject<Void, Never>()
        @State var cancellable: AnyCancellable?
        func waitForButtonTap(using buttonTapPublisher: PassthroughSubject<Void, Never>) async {
            await withCheckedContinuation { continuation in
                let cancellable = tapSubject.first().sink(receiveValue: { _ in
                    continuation.resume()
                })
                self.cancellable = cancellable
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
