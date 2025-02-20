//
//  File.swift
//  My App
//
//  Created by Felipe on 05/02/25.
//

import Foundation
import SwiftUI

@Observable
class FontManager {
    static var shared = FontManager()
    
    private init() {
        guard let cfURL = Bundle.main.url(forResource: "Pokemon Fire Red", withExtension: ".ttf") else {
            return
        }
        CTFontManagerRegisterFontsForURL(cfURL as CFURL, .process, nil)
    }
    
    func setFont(size: CGFloat) -> Font {
        let uiFont = UIFont(name: "Pokemon Fire Red", size: size)

        return Font(uiFont!)
    }
}
