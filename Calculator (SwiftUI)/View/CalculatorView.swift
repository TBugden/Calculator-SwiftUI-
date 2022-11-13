//
//  ContentView.swift
//  Calculator (SwiftUI)
//
//  Created by Jesse Chan on 11/13/22.
//

import SwiftUI

struct CalculatorView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel = CalculatorViewModel()
    
    let screenSize = UIScreen.main.bounds.size
    let feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        VStack {
            ResultsView()
            CalculatorButtonsView()
        }
        .edgesIgnoringSafeArea(.top)
        
        // Toast banner modifier, to display error messages to the user
        .modifier (
            ToastBanner (
                message: viewModel.toastMessage,
                clearMessage: {
                    viewModel.toastMessage = nil
                }
            )
        )
        .background (
            LinearGradient(
                colors: [.gray.opacity(0.1), Color.gray.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
    
    //MARK: - Results View
    @ViewBuilder
    func ResultsView()->some View {
        VStack(alignment: .trailing, spacing: 0) {
            Spacer()
            if !viewModel.previousResults.isEmpty {
                PreviousResults()
                Divider()
            }
            Text(viewModel.visibleWorkings)
                .font(.title)
                .foregroundColor(.gray)
                .opacity(0.75)
                .frame(minHeight: 35)
            HStack {
                Text(viewModel.lastResult == nil ? "" : "=")
                    .font(.system(size: 40))
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
                    .opacity(0.35)
                    .padding(.trailing)
                Text(viewModel.displayValue)
                    .font(.system(size: 75))
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .fontWeight(.semibold)
                    .opacity(0.55)
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func PreviousResults()->some View {
        ScrollView {
            VStack(alignment: .trailing) {
                ForEach(viewModel.previousResults, id: \.self) { result in
                    Text(result)
                        .font(.title)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                        .opacity(0.75)
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                }
            }
        }
        .scrollDisabled(true)
        .mask {
            LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
        }
        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
    
    //MARK: - Calculator Buttons
    @ViewBuilder
    func CalculatorButtonsView()->some View {
        HStack(spacing: 0) {
            NumberPad(width: screenSize.width / 1.35)
            OperatorButtons(width: screenSize.width / 4.25)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    func NumberPad(width: CGFloat)->some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 11.5) {
            ForEach([CalculatorButtons.functions, CalculatorButtons.numbers.reversed()].flatMap{$0}, id: \.self) { button in
                
                let color: ButtonColor = CalculatorButtons.functions.contains(button) ? .orange : .number
                NumberPadButton(label: button, color: color, size: .small)
                
                if button == "0" {
                    
                    // Delete button placed after 0 key
                    NumberPadButton(label: "", color: .number, size: .small)
                        .overlay {
                            Image(systemName: "delete.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                                .opacity(0.5)
                                .offset(x: -2.5)
                        }
                } else if button == "1" {
                    
                    // Decimal button placed before 0 key
                    NumberPadButton(label: ".", color: .number, size: .small)
                }
            }
        }
        .padding(.horizontal)
        .frame(width: width)
    }
    
    @ViewBuilder
    func OperatorButtons(width: CGFloat)->some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15)], spacing: 11.5) {
            ForEach(CalculatorButtons.operators, id: \.self) { button in
                NumberPadButton(label: button, color: .purple, size: button == "=" ? .medium : .small)
            }
        }
        .padding(.trailing)
        .frame(width: width)
    }
    
    @ViewBuilder
    func NumberPadButton(label: String, color: ButtonColor, size: ButtonSize)->some View {
        let darkMode = colorScheme == .dark
        
        let aspectRatio: CGFloat? = {
            switch size {
            case .small: return 1.15
            case .medium: return 0.535
            }
        }()
        
        let boldButton = label == "C" || label == "="
        
        Button {
            feedback.impactOccurred()
            viewModel.buttonPressed(label)
        } label: {
            let keyColor = darkMode ? color.keyColorDarkMode : color.keyColor
            
            RoundedRectangle(cornerRadius: .infinity)
                .aspectRatio(aspectRatio, contentMode: .fit)
                .foregroundStyle(
                    keyColor
                    
                    // Skeuomorphic styling for light mode
                        .shadow(.inner(color: Color.gray.opacity(darkMode ? 0 : 0.07), radius: 5, x: 2.5, y: 2.5))
                        .shadow(.inner(color: Color.white.opacity(darkMode ? 0 : 0.25), radius: 1, x: -2.5, y: -2.5))
                )
                .shadow(color: Color.white.opacity(darkMode ? 0 : 0.75), radius: 1, x: -2.5, y: -2.5)
                .shadow(color: Color.gray.opacity(darkMode ? 0 : 0.35), radius: 4.5, x: 2.5, y: 2.5)
            
                .overlay {
                    Text(label)
                        .font(.title)
                        .fontWeight(boldButton ? .bold : .medium)
                        .foregroundColor(darkMode ? .white : color.symbolColor.opacity(0.5))
                        .shadow(radius: color == .number ? 5 : 0)
                }
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
