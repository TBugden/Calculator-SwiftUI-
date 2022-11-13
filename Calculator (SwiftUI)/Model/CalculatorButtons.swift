//
//  CalculatorButtons.swift
//  Calculator (SwiftUI)
//
//  Created by Jesse Chan on 11/13/22.
//

import SwiftUI

struct CalculatorButtons {
    static let numbers = Array(0...9).map { String($0) }
    static let operators = ["x", "÷", "-", "+", "="]
    static let functions = ["C", "(", ")", "√", "%", "±"]
}

enum ButtonSize {
    case small
    case medium
}

enum ButtonColor {
    case orange
    case purple
    case number
    
    var keyColor: Color {
        switch self {
        case .orange:
            return Color("buttonFaceOrange")
        case .purple:
            return Color("buttonFacePurple")
        case .number:
            return Color("buttonFace")
        }
    }
    
    var symbolColor: Color {
        switch self {
        case .orange:
            return Color("buttonSymbolOrange")
        case .purple:
            return Color("buttonSymbolPurple")
        case .number:
            return .black
        }
    }
    
    var keyColorDarkMode: Color {
        switch self {
        case .orange:
            return Color.orange.opacity(0.1)
        case .purple:
            return Color.purple.opacity(0.1)
        case .number:
            return Color.gray.opacity(0.1)
        }
    }
}
