//
//  File.swift
//  My App
//
//  Created by Felipe on 06/02/25.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

