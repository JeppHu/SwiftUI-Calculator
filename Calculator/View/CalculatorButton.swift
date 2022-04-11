//
//  CalculatorButton.swift
//  Calculator
//
//  Created by jingpeng.hu on 2021/1/19.
//

import SwiftUI

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(foregroundColor)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        })
    }
}

struct Previews_CalculatorButton_Preview: PreviewProvider {
    static var previews: some View {
        CalculatorButton(title: "+", size: CGSize(width: 88, height: 88), backgroundColorName: "operatorBackground", foregroundColor: Color("commandForeground")) {
            
        }
    }
}
