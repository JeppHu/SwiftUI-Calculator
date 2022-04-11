//
//  CalculatorButtonRow.swift
//  Calculator
//
//  Created by jingpeng.hu on 2021/1/19.
//

import SwiftUI

struct CalculatorButtonRow: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    @EnvironmentObject var model: CalculatorModel

    let row: [CalculatorButtonItem]

    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName, foregroundColor: item.foregroundColor) {
//                    brain = brain.apply(item: item)
                    model.apply(item: item)
                }
            }
        }
    }
}
