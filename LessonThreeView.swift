//
//  SwiftUIView.swift
//  My App
//
//  Created by Felipe on 12/02/25.
//

import SwiftUI

struct LessonThreeView: View {
    
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
    
    let columnsLetters = [
        GridItem(.fixed(103)), // Primeira coluna
        GridItem(.fixed(103)), // Segunda coluna
        GridItem(.fixed(103)), // Terceira coluna
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
    
    @State var isShowingTutorial: IsShowingTutorial = .notShowing
    @State var isShowingKeyboard: Bool = false
    
    @State var buttonWorking: Bool = true
    
    var didSelectedLetterK: Bool {
        isShowingTutorial == .showing && selectedLetterButton == "k"
    }
    
    var didSelectedLetterW: Bool {
        isShowingTutorial == .showing && selectedLetterButton == "w"
    }
    
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
                    router = .completed
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
                TutorialViewComponent(router: router, isShowingTutorial: $isShowingTutorial, falas: falas, isShowingKeyboardTutorial: $isShowingKeyboard, checkRepresentation: checkRepresentationButton)
                if isShowingKeyboard {
                    VStack {
                        HStack {
                            leftWingContainerTutorial
                            brailleKeyboard
                            rightWingContainerTutorial
                        }
                        Spacer()
                    }
                    .padding(.vertical, 32)
                    .transition(.opacity)
                    .onDisappear {
                        buttonWorking.toggle()
                    }
                }
            case .notShowing:
                EmptyView()
            }
        }
        .animation(.default, value: isShowingKeyboard)
        .animation(.default, value: didSelectedLetterK)
        .animation(.default, value: didSelectedLetterW)
        .onAppear {
            isShowingTutorial = .showing
        }
        .onChange(of: isShowingTutorial) { oldValue, newValue in
            selectedButtons.removeAll()
            selectedLetterButton = ""
            selectedRepresentation = [
                [0, 0],
                [0, 0],
                [0, 0]
            ]
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
                    .disabled(buttonWorking)
                }
            }
        }
        .frame(height: 586)
    }
    
    var leftWingContainer: some View {
        VStack {
            LazyVGrid(columns: columnsLetters, spacing: 8) {
                ForEach(["k", "l", "m", "n", "o", "p"], id: \.self) { letter in
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
            
            HStack {
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "q")
                    hitButton()
                } label: {
                    Image(selectedLetterButton == "q" ? "q" + "ButtonSelected" : "q" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "r")
                    hitButton()
                } label: {
                    Image(selectedLetterButton == "r" ? "r" + "ButtonSelected" : "r" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
            }
        }
    }
    
    var rightWingContainer: some View {
        VStack {
            LazyVGrid(columns: columnsLetters, spacing: 8) {
                ForEach(["s", "t", "u", "v", "w", "x"], id: \.self) { letter in
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
            
            HStack {
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "y")
                    hitButton()
                } label: {
                    Image(selectedLetterButton == "y" ? "y" + "ButtonSelected" : "y" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "z")
                    hitButton()
                } label: {
                    Image(selectedLetterButton == "z" ? "z" + "ButtonSelected" : "z" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
            }

        }
    }
    
    var leftWingContainerTutorial: some View {
        VStack {
            LazyVGrid(columns: columnsLetters, spacing: 8) {
                ForEach(["k", "l", "m", "n", "o", "p"], id: \.self) { letter in
                    Button {
                        // MARK: Selecionar a representação
                        checkRepresentationButton(for: letter)
                    } label: {
                        Image(selectedLetterButton == letter ? letter + "ButtonSelected" : letter + "Button")
                            .resizable()
                    }
                    .frame(width: 103, height: 138)
                    .disabled(isShowingTutorial == .showing)
                    .opacity(letter == "k" && selectedLetterButton == "k" ? 1 : 0)
                }
            }
            
            HStack {
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "q")
                } label: {
                    Image(selectedLetterButton == "q" ? "q" + "ButtonSelected" : "q" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
                .disabled(true)
                .opacity(0)

                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "r")
                } label: {
                    Image(selectedLetterButton == "r" ? "r" + "ButtonSelected" : "r" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
                .disabled(true)
                .opacity(0)
            }
        }
    }
    
    var rightWingContainerTutorial: some View {
        VStack {
            LazyVGrid(columns: columnsLetters, spacing: 8) {
                ForEach(["s", "t", "u", "v", "w", "x"], id: \.self) { letter in
                    Button {
                        // MARK: Selecionar a representação
                        checkRepresentationButton(for: letter)
                    } label: {
                        Image(selectedLetterButton == letter ? letter + "ButtonSelected" : letter + "Button")
                            .resizable()
                    }
                    .frame(width: 103, height: 138)
                    .disabled(isShowingTutorial == .showing)
                    .opacity(letter == "w" && selectedLetterButton == "w" ? 1 : 0)
                }
            }
            
            HStack {
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "y")
                } label: {
                    Image(selectedLetterButton == "y" ? "y" + "ButtonSelected" : "y" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
                .disabled(true)
                .opacity(0)
                
                Button {
                    // MARK: Selecionar a representação
                    checkRepresentationButton(for: "z")
                } label: {
                    Image(selectedLetterButton == "z" ? "z" + "ButtonSelected" : "z" + "Button")
                        .resizable()
                }
                .frame(width: 103, height: 138)
                .disabled(true)
                .opacity(0)
            }
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
    LessonThreeView(router: .constant(.lessonThree))
}
