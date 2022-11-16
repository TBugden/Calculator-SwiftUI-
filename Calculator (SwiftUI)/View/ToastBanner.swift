//
//  ErrorMessageToast.swift
//  Calculator (SwiftUI)
//
//  Created by Jesse Chan on 11/14/22.
//

import SwiftUI

/// Show a toast banner over the top of the view
struct ToastBanner: ViewModifier {
    @State var shakeAnimation = false
    @State var flashAnimation = false
    
    let message: String?
    
    let clearMessage: ()->Void
    
    let workItem = DispatchWorkItem {
        
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if let message = message {
                VStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundColor(Color("buttonFace"))
                        .frame(height: 50)
                        .overlay {
                            ZStack {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .opacity(0.1)
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .foregroundColor(.red)
                                            .opacity(flashAnimation ? 0.25 : 0)
                                        Text(message)
                                            .font(.caption)
                                            .lineLimit(2)
                                            .opacity(0.5)
                                            .offset(x: shakeAnimation ? 2.5 : 0)
                                            .animation(.linear(duration: 0.1).repeatCount(3), value: shakeAnimation)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    Spacer()
                }
                .onAppear {
                    shakeAnimation = true
                    flashAnimation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { withAnimation { flashAnimation = false }}
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        
                        withAnimation(.easeOut(duration: 0.25)) {
                            clearMessage()
                            shakeAnimation = false
                        }
                    }
                }
                .onTapGesture {
                    clearMessage()
                    shakeAnimation = false
                }
            }
        }
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
