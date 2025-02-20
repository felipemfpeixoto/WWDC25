//
//  SwiftUIView.swift
//  My App
//
//  Created by Felipe on 08/02/25.
//

import SwiftUI

struct LessonOneView: View {
    
    @Binding var router: Router
    
    let brailleManager: BrailleManager = BrailleManager()
    
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
    
    let columns: [GridItem] = [
        GridItem(.fixed(175)),
        GridItem(.fixed(175)),
        GridItem(.fixed(175))
    ]
    
    @State var selectedButtons: [String] = []
    
    @State var selectedRepresentation: [[Int]] = [
        [0, 0],
        [0, 0],
        [0, 0]
    ]
    @State var representedText: String?
    let representedTextFont: Font = FontManager.shared.setFont(size: 250)
    
    @State var isShowingTutorial: IsShowingTutorial = .notShowing
    
    @State var buttonWorking: Bool = true
    @State var isShowingKeyboardTutorial: Bool = false
    
    var falas: [String] {
        FalasManager.shared.getFalas(for: router)
    }
    @State var falaIndex: Int = 0
    @State var text: String = ""
    let falaFont: Font = FontManager.shared.setFont(size: 50)
    @State var didEndTextAnimation: Bool = false
    @State var isAnimation: Bool = false
    
    var body: some View {
        ZStack {
            Color(.pretoDeFundo)
                .ignoresSafeArea()
            VStack {
                brailleKeyboard
                Spacer()
                Button {
                    // MARK: Terminar a lesson one
                    router = .menu2
                } label: {
                    Image("nextButton")
                        .resizable()
                        .scaledToFit()
                }
                .frame(height: 121)
            }
            .padding(.vertical, 32)
            
            symbolContainer
            
            switch isShowingTutorial {
            case .showing:
                ZStack {
                    TutorialViewComponent(router: router, isShowingTutorial: $isShowingTutorial, falas: falas, isShowingKeyboardTutorial: $isShowingKeyboardTutorial, checkRepresentation: nil)
                    if isShowingKeyboardTutorial {
                        VStack {
                            brailleKeyboard
                            Spacer()
                        }
                        .padding(.vertical, 32)
                        .onDisappear {
                            buttonWorking.toggle()
                        }
                    }
                }
            case .notShowing:
                EmptyView()
            }
        }
        .animation(.default, value: isShowingKeyboardTutorial)
        .animation(.default, value: isShowingTutorial)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                isShowingTutorial = .showing
            }
        }
    }
    
    var brailleKeyboard: some View {
        ZStack {
            Image("brailleKeyboardBackground")
                .resizable()
                .scaledToFit()
            LazyHGrid(rows: columns, spacing: 64) {
                ForEach(items, id:\.self) { imageName in
                    Button {
                        // Atividade do botao
                        if let numberCharacter = imageName.first(where: { $0.isNumber }) {
                            let numberString = String(numberCharacter)
                            let number: Int = Int(numberString)!
                            
                            let lineIndex = (number - 1) % 3
                            let columnIndex = (number - 1) / 3
                            
                            if selectedRepresentation[lineIndex][columnIndex] == 0 {
                                selectedRepresentation[lineIndex][columnIndex] = 1
                            } else {
                                selectedRepresentation[lineIndex][columnIndex] = 0
                            }
                            
                            representedText = brailleManager.checkRepresentation(for: selectedRepresentation)
                            
                            if !selectedButtons.contains(imageName) {
                                selectedButtons.append(imageName)
                                hitButton()
                            } else {
                                selectedButtons.remove(at: selectedButtons.firstIndex(of: imageName)!)
                                diselectButton()
                            }
                        }
                    } label: {
                        Image(selectedButtons.contains(imageName) ? (imageName + "Selected") : imageName)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 105)
                    .disabled(buttonWorking)
                }
            }
        }
        .frame(height: 586)
    }
    
    var symbolContainer: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("Symbol")
                        .font(symbolFont)
                        .foregroundStyle(Color(.azulAccent))
                    ZStack {
                        Image("characterFrame")
                            .resizable()
                            .scaledToFit()
                        Text(representedText != nil ? representedText! : "?")
                            .font(representedTextFont)
                            .foregroundStyle(.white)
                            .padding(.bottom, 32)
                            .padding(.leading, 24)
                    }
                    .frame(height: 277)
                }
                .padding(.trailing, 64)
            }
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    LessonOneView(router: .constant(.lessonOne))
}
