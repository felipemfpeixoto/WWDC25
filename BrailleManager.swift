//
//  File.swift
//  My App
//
//  Created by Felipe on 08/02/25.
//

import Foundation

class BrailleManager {
    
    // MARK: Disctionary responsible for storing all the characters ans its respective representations in the Braille system
    private let brailleAlphabet: [String: [[Int]]] = [
        "A": [[1, 0], [0, 0], [0, 0]],
        "B": [[1, 0], [1, 0], [0, 0]],
        "C": [[1, 1], [0, 0], [0, 0]],
        "D": [[1, 1], [0, 1], [0, 0]],
        "E": [[1, 0], [0, 1], [0, 0]],
        "F": [[1, 1], [1, 0], [0, 0]],
        "G": [[1, 1], [1, 1], [0, 0]],
        "H": [[1, 0], [1, 1], [0, 0]],
        "I": [[0, 1], [1, 0], [0, 0]],
        "J": [[0, 1], [1, 1], [0, 0]],
        "K": [[1, 0], [0, 0], [1, 0]],
        "L": [[1, 0], [1, 0], [1, 0]],
        "M": [[1, 1], [0, 0], [1, 0]],
        "N": [[1, 1], [0, 1], [1, 0]],
        "O": [[1, 0], [0, 1], [1, 0]],
        "P": [[1, 1], [1, 0], [1, 0]],
        "Q": [[1, 1], [1, 1], [1, 0]],
        "R": [[1, 0], [1, 1], [1, 0]],
        "S": [[0, 1], [1, 0], [1, 0]],
        "T": [[0, 1], [1, 1], [1, 0]],
        "U": [[1, 0], [0, 0], [1, 1]],
        "V": [[1, 0], [1, 0], [1, 1]],
        "W": [[0, 1], [1, 1], [0, 1]],
        "X": [[1, 1], [0, 0], [1, 1]],
        "Y": [[1, 1], [0, 1], [1, 1]],
        "Z": [[1, 0], [0, 1], [1, 1]]
    ]
    
    func checkRepresentation(for matrix: [[Int]]) -> String? {
        return brailleAlphabet.first(where: { $1 == matrix })?.key
    }
    
    func getRepresentation(for letter: String) -> [[Int]]? {
        return brailleAlphabet[letter.uppercased()]
    }
}
