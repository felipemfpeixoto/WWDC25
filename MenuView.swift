//
//  SwiftUIView.swift
//  My App
//
//  Created by Felipe on 07/02/25.
//

import SwiftUI

enum MenuState {
    case firstLesson
    case secondLesson
    case thirdLesson
    case completed
}

enum IsShowingTutorial {
    case showing
    case notShowing
}


struct MenuView: View {
    
    @Binding var router: Router
    
    let menuState: MenuState
    @State var isShowingTutorial: IsShowingTutorial = .notShowing
    
    @State var falaFont: Font = FontManager.shared.setFont(size: 50)
    @State var text: String = ""
    @State var didEndTextAnimation: Bool = false
    @State var isAnimation: Bool = false
    
    var falas: [String] {
        FalasManager.shared.getFalas(for: router)
    }
    @State var falaIndex: Int = 0
    
    let textures: [String] = [
        "zicoTalking1Grande",
        "zicoTalking2Grande",
        "zicoTalking3Grande",
        "zicoTalking2Grande"
    ]
    @State var textureIndex: Int = 0
    
    var body: some View {
        ZStack {
            backgroundComponents
            
            menuButtons
            
            switch isShowingTutorial {
                case .showing:
                    tutorialComponent
                        .transition(.opacity)
                case .notShowing:
                    EmptyView()
                        .transition(.opacity)
            }
        }
        .onAppear {
            typeWriter(falas[falaIndex])
            falaFont = FontManager.shared.setFont(size: 50)
            
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
        }
        .animation(.default, value: isShowingTutorial)
        .onAppear {
            
            AudioManager.shared.playOnce()
            
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                isShowingTutorial = .showing
            }
        }
    }
    
    // TODO: (0) Um dos switch cases vai ficar aqui
    var backgroundComponents: some View {
        ZStack {
            Color(.pretoDeFundo)
                .ignoresSafeArea()
            
            switch menuState {
            case .firstLesson:
                VStack {
                    Image("mensagemBraille1Fundo")
                    Spacer()
                }
            case .secondLesson:
                VStack {
                    Image("mensagemBraille2")
                        .resizable()
                        .frame(width: 990, height: 580)
                    Spacer()
                }
            case .thirdLesson:
                VStack {
                    Image("mensagemBraille3")
                        .resizable()
                        .frame(width: 990, height: 580)
                    Spacer()
                }
            case .completed:
                VStack {
                    Image("mensagemBrailleCompleted")
                        .resizable()
                        .frame(width: 990, height: 580)
                    Spacer()
                }
            }
        }
    }
    
    var menuButtons: some View {
        VStack {
            Spacer()
            ZStack {
                HStack(spacing: 48) {
                    Button {
                        router = .lessonOne
                    } label: {
                        Image(menuState == .firstLesson ? "buttonLesson1Active" : "buttonLesson1Completed")
                            .resizable()
                            .frame(width: 271.68, height: 262.47)
                    }
                    .disabled(menuState != .firstLesson)
                    
                    Button {
                        router = .lessonTwo
                    } label: {
                        Image(menuState == .secondLesson ? "buttonLesson2Active" : menuState == .firstLesson ? "buttonLesson2Locked" : "buttonLesson2Completed")
                            .resizable()
                            .frame(width: 271.68, height: 262.47)
                    }
                    .disabled(menuState != .secondLesson)
                    
                    Button {
                        router = .lessonThree
                    } label: {
                        Image(menuState == .thirdLesson ? "buttonLesson3Active" : menuState == .completed ? "buttonLesson3Completed" : "buttonLesson3Locked")
                            .resizable()
                            .frame(width: 271.68, height: 262.47)
                    }
                    .disabled(menuState != .thirdLesson)
                }
                .opacity(menuState == .completed ? 0.5 : 1)
                
                if menuState == .completed {
                    Button {
                        router = .onBoarding
                    } label: {
                        Image("playAgainButton")
                            .resizable()
                    }
                    .frame(width: 645, height: 175)

                }
            }
        }
    }
    
    var tutorialComponent: some View {
        ZStack {
            Color.black
                .opacity(0.75)
                .ignoresSafeArea()
            switch menuState {
            case .firstLesson:
                VStack {
                    Image("mensagemBraille1Fundo")
                    Spacer()
                }
            case .secondLesson:
                VStack {
                    Image("mensagemBraille2")
                        .resizable()
                        .frame(width: 990, height: 580)
                    Spacer()
                }
            case .thirdLesson:
                VStack {
                    Image("mensagemBraille3")
                        .resizable()
                        .frame(width: 990, height: 580)
                    Spacer()
                }
            case .completed:
                VStack {
                    Image("mensagemBrailleCompleted")
                        .resizable()
                        .frame(width: 990, height: 580)
                    Spacer()
                }
            }
            balaoComponent
        }
        .transition(.opacity)
    }
    
    var balaoComponent: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    ZStack {
                        Image("balaoFala")
                            .resizable()
                            .frame(width: 911,height: 165)
                        textBalaoFala
                    }
                    .frame(width: 911, height: 165)
                    .onTapGesture {
                        if didEndTextAnimation {
                            if falaIndex != falas.count - 1 {
                                text = ""
                                falaIndex += 1
                                typeWriter(falas[falaIndex])
                                didEndTextAnimation.toggle()
                                
                                if falaIndex % 3 == 0 {
                                    AudioManager.shared.playOnce()
                                }
                                
                            } else {
                                isShowingTutorial = .notShowing
                            }
                        }
                    }
                    Image(textures[textureIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 259)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    var textBalaoFala: some View {
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

#Preview("First Menu") {
    MenuView(router: .constant(.menu), menuState: .firstLesson)
}


#Preview("Second Menu") {
    MenuView(router: .constant(.menu2), menuState: .secondLesson)
}


#Preview("Third Menu") {
    MenuView(router: .constant(.menu3), menuState: .thirdLesson)
}


#Preview("Completed Menu") {
    MenuView(router: .constant(.completed), menuState: .completed)
}

// 858, 389, 100
