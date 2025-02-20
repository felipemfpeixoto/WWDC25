//
//  SwiftUIView.swift
//  My App
//
//  Created by Felipe on 09/02/25.
//

import SwiftUI

struct LessonTwoView: View {
    
    @Binding var router: Router
    
    let brailleManager: BrailleManager = BrailleManager()
    
    var falas: [String] {
        FalasManager.shared.getFalas(for: router)
    }
    
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
    
    @State var selectedLetterButton: String = ""
    
    let columnsLetters = [
        GridItem(.fixed(103)), // Primeira coluna
        GridItem(.fixed(103)), // Primeira coluna
    ]
    
    @State var isShowingTutorial: IsShowingTutorial = .notShowing
    @State var isShowingKeyboard: Bool = false
    
    var body: some View {
        ZStack {
            Color(.pretoDeFundo)
                .ignoresSafeArea()
            
            VStack {
                // MARK: Aqui vao ficar os botoes das letras e o teclado
                HStack {
                    leftWingContainer
                    brailleKeyboard
                    rightWingContainer
                }
                Spacer()
                // MARK: Aqui vai ficar o botao de next
                Button {
                    // MARK: Terminar a lesson one
                    router = .menu3
                } label: {
                    Image("nextButton")
                        .resizable()
                        .scaledToFit()
                }
                .frame(height: 121)
            }
            .padding(.vertical, 32)
            
            switch isShowingTutorial {
            case .showing:
                // TODO: (0) Mudar o isShowingKeyboardTutorial depois de implementar o mesmo
                TutorialViewComponent(router: router, isShowingTutorial: $isShowingTutorial, falas: falas, isShowingKeyboardTutorial: $isShowingKeyboard, checkRepresentation: nil)
                if isShowingKeyboard {
                    VStack {
                        brailleKeyboardTutorialComponent
                        Spacer()
                    }
                    .padding(.vertical, 32)
                    .transition(.opacity)
                }
            case .notShowing:
                EmptyView()
            }
        }
        .animation(.default, value: isShowingKeyboard)
        .onAppear {
            isShowingTutorial = .showing
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
                            
                            if !selectedButtons.contains(imageName) {
                                selectedButtons.append(imageName)
                                hitButton()
                            } else {
                                selectedButtons.remove(at: selectedButtons.firstIndex(of: imageName)!)
                                diselectButton()
                            }
                            
                            selectedLetterButton = brailleManager.checkRepresentation(for: selectedRepresentation)?.lowercased() ?? ""
                        }
                    } label: {
                        Image(selectedButtons.contains(imageName) ? (imageName + "Selected") : imageName)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 105)
//                    .disabled(buttonWorking)
                }
            }
        }
        .frame(height: 586)
    }
    
    var leftWingContainer: some View {
        VStack {
            LazyVGrid(columns: columnsLetters, spacing: 0) {
                ForEach(["a", "b", "c", "d"], id: \.self) { letter in
                    Button {
                        // MARK: Selecionar a representação
                        checkRepresentationButton(for: letter)
                        hitButton()
                    } label: {
                        Image(selectedLetterButton == letter ? letter + "ButtonSelected" : letter + "Button")
                            .resizable()
                    }
                    .frame(width: 103, height: 138)
                }
                
            }
            
            Button {
                // MARK: Selecionar a representação
                checkRepresentationButton(for: "e")
                hitButton()
            } label: {
                Image(selectedLetterButton == "e" ? "e" + "ButtonSelected" : "e" + "Button")
                    .resizable()
            }
            .frame(width: 103, height: 138)

        }
    }
    
    var rightWingContainer: some View {
        VStack {
            LazyVGrid(columns: columnsLetters, spacing: 8) {
                ForEach(["f", "g", "h", "i"], id: \.self) { letter in
                    Button {
                        // MARK: Selecionar a representação
                        checkRepresentationButton(for: letter)
                        hitButton()
                    } label: {
                        Image(selectedLetterButton == letter ? letter + "ButtonSelected" : letter + "Button")
                            .resizable()
                    }
                    .frame(width: 103, height: 138)
                }
                
            }
            
            Button {
                // MARK: Selecionar a representação
                checkRepresentationButton(for: "j")
                hitButton()
            } label: {
                Image(selectedLetterButton == "j" ? "j" + "ButtonSelected" : "j" + "Button")
                    .resizable()
            }
            .frame(width: 103, height: 138)

        }
    }
    
    var brailleKeyboardTutorialComponent: some View {
        VStack {
            ZStack {
                Image("brailleKeyboardTop")
                    .resizable()
                    .scaledToFit()
                VStack {
                    LazyHGrid(rows: columns.dropLast(), spacing: 64) {
                        ForEach(items.filter({ $0.contains("1") || $0.contains("2") || $0.contains("4") || $0.contains("5") }), id:\.self) { imageName in
                            Image(selectedButtons.contains(imageName) ? (imageName + "Selected") : imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 105)
                        }
                    }
                    Spacer()
                }
            }
            .frame(height: 391)
        }
    }
    
    func checkRepresentationButton(for letter: String) {
        if let representation = brailleManager.getRepresentation(for: letter) {
            selectedRepresentation = representation
            
            selectedButtons.removeAll()
            
            for linha in selectedRepresentation.indices {
                for coluna in selectedRepresentation[linha].indices {
                    if selectedRepresentation[linha][coluna] == 1 {
                        let linhaIndex = linha + 1
                        let colunaIndex = coluna == 0 ? 0 : 3
                        let number = linhaIndex + colunaIndex
                        
                        selectedButtons.append("button\(number)Braille")
                    }
                }
            }
            
            selectedLetterButton = letter
        }
    }
}

#Preview {
    LessonTwoView(router: .constant(.lessonTwo))
}
