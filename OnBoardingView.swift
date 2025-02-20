import SwiftUI
import UIKit
import SpriteKit

struct OnBoardingView: View {
    
    @State var titleFont: Font?
    @State var subTitleFont: Font?
    @State var falaFont: Font?
    @State var creditsFont: Font?
    
    @State var isShowingTitle: Bool = true
    
    @Binding var router: Router
    
    let audioManager = AudioManager.shared
    
    var spriteScene: SKScene = {
        let size = UIScreen.main.bounds.size
        let spriteView = WelcomeScene(size: size)
        spriteView.size = size
        spriteView.scaleMode = .aspectFill
        spriteView.anchorPoint = .init(x: 0, y: 0)
        
        return spriteView
    }()
    
    @State private var text = ""
    var falas: [String] {
        FalasManager.shared.getFalas(for: router)
    }
    @State var falaIndex: Int = 0
    @State var didEndTextAnimation: Bool = false
    @State var isAnimation: Bool = false
    @State var textSpeed: CGFloat = 0.05
    
    var body: some View {
        ZStack {
            Color(.pretoDeFundo)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                GeometryReader { geo in
                    VStack {
                        SpriteView(scene: spriteScene)
                            .ignoresSafeArea()
                    }
                }
            }
            
            if isShowingTitle {
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Braille with Zico")
                                .font(titleFont)
                                .foregroundStyle(.white)
                            
                            Text("A Braille Experience")
                                .font(subTitleFont)
                                .foregroundStyle(.gray)
                            Spacer()
                            Button {
                                withAnimation {
                                    isShowingTitle.toggle()
                                }
                                if let cena = spriteScene as? WelcomeScene {
                                    cena.startTalking()
                                    
                                    audioManager.playOnce()
                                }
                            } label: {
                                Image("playButton")
                                    .resizable()
                            }
                            .frame(width: 310, height: 150)
                        }
                        Spacer()
                        VStack {
                            Text("Music by Dvir from Pixabay")
                                .font(creditsFont)
                                .foregroundStyle(Color(uiColor: .darkGray))
                                .opacity(0.5)
                            Spacer()
                        }
                    }
                }
                .padding(32)
                .transition(.slide)
            }
            
            if !isShowingTitle {
                balaoDeFala
                    .onTapGesture {
                        if didEndTextAnimation {
                            if falaIndex != falas.count - 1 {
                                text = ""
                                falaIndex += 1
                                typeWriter(falas[falaIndex])
                                didEndTextAnimation.toggle()
                                textSpeed = 0.05
                                
                                if (falaIndex + 1) % 3 == 0 {
                                    AudioManager.shared.playOnce()
                                }
                            } else {
                                router = .menu
                            }
                        } else {
                            textSpeed = 0.015
                        }
                    }
            }
        }
        .onAppear {
            titleFont = FontManager.shared.setFont(size: 120)
            subTitleFont = FontManager.shared.setFont(size: 50)
            creditsFont = FontManager.shared.setFont(size: 25)
            
            audioManager.backgroundAudioPlayer?.play()
        }
    }
    
    var balaoDeFala: some View {
        VStack {
            Spacer()
            ZStack {
                Image("balaoFala")
                    .resizable()
                    .frame(width: 1132.73, height: 165)
                HStack {
                    Text(text)
                        .font(falaFont)
                        .frame(width: 931, alignment: .leading)
                        .lineLimit(2, reservesSpace: true)
                        .foregroundStyle(.black)
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
            }
        }
        .onAppear {
            typeWriter(falas[falaIndex])
            falaFont = FontManager.shared.setFont(size: 50)
            
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                isAnimation.toggle()
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
