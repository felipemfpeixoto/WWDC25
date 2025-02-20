//
//  SwiftUIView.swift
//  My App
//
//  Created by Felipe on 06/02/25.
//

import SwiftUI

struct TesteView: View {
    @State private var text = ""
    @State private var finalText = "Hello, World!"
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(text)
                    .frame(width: 300, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
            }
        }
        
        .onAppear {
            typeWriter(finalText)
        }
    }
    func typeWriter(at position: Int = 0, _ text: String) {
      if position < finalText.count {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.text.append(finalText[position])
            typeWriter(at: position + 1, text)
        }
      }
    }
}

#Preview {
    TesteView()
}
