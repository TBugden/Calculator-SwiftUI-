//
//  CalculatorViewModel.swift
//  Calculator (SwiftUI)
//
//  Created by Jesse Chan on 11/14/22.
//

import SwiftUI

class CalculatorViewModel: ObservableObject {
    let feedback = UINotificationFeedbackGenerator()
    
    let numbers = CalculatorButtons.numbers
    let operators = CalculatorButtons.operators
    let functions = CalculatorButtons.functions
    
    @Published var displayValue = "0"
    @Published var visibleWorkings: String = ""
    @Published var previousResults: [String] = []
    
    var lastResult: String?

    @Published var toastMessage: String?

    /// Action taken using a symbol from the CalculatorButtons struct
    func buttonPressed(_ symbol: String) {
        switch symbol {
        case _ where numbers.contains(symbol):
            visibleWorkings += symbol
            calculateResults()
        case _ where operators.contains(symbol): operatorPressed(symbol)
        case _ where functions.contains(symbol): etcPressed(symbol)
        case ".": decimalPressed()
        case "": backspacePressed()
            
        default: errorMessage(.buttonNotFound)
        }
    }
    
    //MARK: - Operators
    private func operatorPressed(_ operatorSymbol: String) {
        
        // If previous result exists while visibleWorkings is empty and user has not cleared:
        // -> The previous result is added to visibleWorkings, followed by the operator
        guard !visibleWorkings.isEmpty else {
            if operatorSymbol != "=" && lastResult != nil {
                visibleWorkings = lastResult! + operatorSymbol
            } else {
                feedback.notificationOccurred(.error)
            }
            return
        }
        
        // Continue only if the last character is not an operator
        guard let lastChar = visibleWorkings.last, !operators.contains(lastChar.description) else {
            feedback.notificationOccurred(.error)
            return
        }
        
        if operatorSymbol == "=" {
            calculateResults()
            previousResults.insert(visibleWorkings + " = " + displayValue, at: 0)
            visibleWorkings = ""
        } else {
            visibleWorkings += operatorSymbol
        }
    }
    
    //MARK: - Backspace and Decimal
    private func backspacePressed() {
        guard !visibleWorkings.isEmpty else {
            feedback.notificationOccurred(.error)
            return
        }
        visibleWorkings.removeLast()
        if visibleWorkings.isEmpty {
            displayValue = "0"
        }
    }
    
    private func decimalPressed() {
            errorMessage(.notYetImplemented)
        }
    
    //MARK: - Functions
    private func etcPressed(_ symbol: String) {
        print("etc pressed")
        switch symbol {
        case "C": clearResults()
        default: errorMessage(.notYetImplemented)
        }
    }
    
    private func clearResults() {
        displayValue = "0"
        lastResult = nil
        visibleWorkings = ""
        previousResults = []
    }
    
    //MARK: - Calculate Results
    private func calculateResults() {
        
        // Format visible workings for NSExpression
        let workings = visibleWorkings
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        // Convert string to NSExpression and calculate result
        let expression = NSExpression(format: workings)
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            displayValue = String(result)
            self.lastResult = String(result)
        } else {
            errorMessage(.calculatingResults)
            return
        }
    }
    
    //MARK: - Error handling
    /// Return an error message to be displayed to the user via toast banner
    private func errorMessage(_ errorMessage: ErrorMessage) {
        self.toastMessage = nil
        withAnimation(.easeIn(duration: 0.25)){
            self.toastMessage = errorMessage.rawValue
        }
    }
}
