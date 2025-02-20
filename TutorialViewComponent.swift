//
//  SwiftUIView.swift
//  My App
//
//  Created by Felipe on 11/02/25.
//

import SwiftUI

struct TutorialViewComponent: View {
    
    let router: Router
    
    @Binding var isShowingTutorial: IsShowingTutorial
    
    @State var text: String = ""
    
    let falas: [String]
    
    let textures: [String] = [
        "zicoTalking1Grande",
        "zicoTalking2Grande",
        "zicoTalking3Grande",
        "zicoTalking2Grande"
    ]
    @State var textureIndex: Int = 0
    
    let symbolFont: Font = FontManager.shared.setFont(size: 75)
    
    let items: [String] = [
        "button1Braille",
        "button2Braille",
        "button3Braille",
        "button4Braille",
        "button5Braille",
        "button6Braille",
    ]
    
    @State var falaIndex: Int = 0
    let falaFont: Font = FontManager.shared.setFont(size: 50)
    @State var didEndTextAnimation: Bool = false
    @State var isAnimation: Bool = false
    
    @State var buttonWorking: Bool = true
//    @State var isShowingKeyboardTutorial: Bool = false
    @Binding var isShowingKeyboardTutorial: Bool
    
    let checkRepresentation: ((_ letter: String) -> Void)?
    
    var body: some View {
        ZStack {
            Color(.pretoDeFundo)
                .opacity(0.75)
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Image(textures[textureIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 259)
                    textContainer
                }
            }
        }
        .transition(.opacity)
        .ignoresSafeArea()
        .animation(.default, value: isShowingKeyboardTutorial)
        .animation(.default, value: isShowingTutorial)
        .onAppear {
            AudioManager.shared.playOnce()
            
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                isAnimation.toggle()
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                if textureIndex < textures.count - 1 {
                    textureIndex += 1
                } else {
                    textureIndex = 0
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                isShowingTutorial = .showing
                typeWriter(falas[falaIndex])
            }
        }
    }
    
    var textContainer: some View {
        ZStack {
            Image("balaoFala")
                .resizable()
                .frame(width: 911,height: 165)
            HStack {
                Text(text)
                    .font(falaFont)
                    .frame(width: 710, alignment: .leading)
                    .lineLimit(2, reservesSpace: true)
                    .foregroundStyle(.black)
                Spacer()
                if didEndTextAnimation {
                        Image("setaBalaoFala")
                            .resizable()
                            .frame(width: 64, height: 42.67)
                            .padding(.bottom, isAnimation ? 8 : -8)
                } else {
                    Rectangle()
                        .frame(width: 64, height: 43)
                        .foregroundStyle(.clear)
                }
            }
            .frame(width: 807)
        }
        .frame(width: 911, height: 165)
        .onTapGesture {
            if didEndTextAnimation {
                if falaIndex != falas.count - 1 {
                    text = ""
                    falaIndex += 1
                    typeWriter(falas[falaIndex])
                    didEndTextAnimation.toggle()
                    
                    if falaIndex == 1 {
                        isShowingKeyboardTutorial.toggle()
                    } else if falaIndex == 5 && router != .lessonThree {
                        isShowingKeyboardTutorial.toggle()
                    } else if router == .lessonThree && falaIndex == 2 {
                        if let checkRepresentation {
                            checkRepresentation("k")
                        }
                    } else if router == .lessonThree && falaIndex == 5 {
                        if let checkRepresentation {
                            checkRepresentation("w")
                        }
                    }
                    
                    if (falaIndex + 1) % 3 == 0 {
                        AudioManager.shared.playOnce()
                    }
                } else {
                    isShowingTutorial = .notShowing
                    buttonWorking.toggle()
                }
            }
        }
    }
    
    func typeWriter(at position: Int = 0, _ text: String) {
        if position < text.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.015) {
                self.text.append(text[position])
                typeWriter(at: position + 1, text)
            }
        } else {
            didEndTextAnimation.toggle()
        }
    }
}

#Preview {
    TutorialViewComponent(router: .menu, isShowingTutorial: .constant(.showing), falas: [
        "Uma vez Flamengo, Sempre Flamengo",
        "Flamengo sempre eu ei de ser",
        "Eh o meu maior prazer, ve-lo brilhar"
    ], isShowingKeyboardTutorial: .constant(true), checkRepresentation: nil)
}
