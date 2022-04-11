//
//  ContentView.swift
//  Calculator
//
//  Created by jingpeng.hu on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    /*
     @State 属性值仅只能在属性本身被设置时会触发 UI 刷新，这个特性让它非常适合用来声明一个值类型的值：因为对值类型的属性的变更，也会触发整个值的重新设置，进而刷新 UI。不过，在把这样的值在不同对象间传递时，状态值将会遵守值语义发生复制。所以，即使我们将 ContentView 里的 brain 通过参数的方式层层向下，传递给 CalculatorButtonPad 和 CalculatorButtonRow，最后在按钮事件中，因为各个层级中的 brain 都不相同，按钮事件对 brain 的变更也只会作用在同层级中，无法对 ContentView 中的 brain 进行改变，因此顶层的 Text 无法更新。
     和 @State 类似，@Binding 也是对属性的修饰，它做的事情是将值语义的属性“转换”为引用语义。对被声明为 @Binding 的属性进行赋值，改变的将不是属性本身，而是它的引用，这个改变将被向外传递。

     1. 对于 @State 修饰的属性的访问，只能发生在 body 或者 body 所调用的方法中。你不能在外部改变 @State 的值，它的所有相关操作和状态改变都应该是和当前 View 挂钩的。如果你需要在多个 View 中共享数据，@State 可能不是很好的选择；如果还需要在 View 外部操作数据，那么 @State 甚至就不是可选项了”
     2. 对于更复杂的情况，例如含有很多属性和方法的类型，可能其中只有很少几个属性需要触发 UI 更新，也可能各个属性之间彼此有关联，那么我们应该选择引用类型和更灵活的可自定义方式。
     */
//    @State private var brain: CalculatorBrain = .left("0")
    // model 现在是一个引用类型 CalculatorModel 的值，使用 @ObservedObject 将它和 ContentView 关联起来。当 CalculatorModel 中的 objectWillChange 发出事件时，body 会被调用，UI 将被刷新。
    // brain 现在是 model 的属性
    // CalculatorButtonPad 接受的是 Binding<CalculatorBrain>。model 的 $ 投影属性返回的是一个 Binding 的内部 Wrapper 类型，对它再进行属性访问（.brain)，将会通过动态查找的方式获取到对应的 Binging<CalculatorBrain>
    @EnvironmentObject var model: CalculatorModel
    @State private var editingHistory = false
    @State private var alertingMessage = false
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历:\(model.history.count)") {
                editingHistory = true
            }.sheet(isPresented: $editingHistory) {
                HistoryView(model: model, editingHistory: $editingHistory)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing
                )
                .onTapGesture(perform: {
                    alertingMessage = true
                })
            CalculatorButtonPad()
                .padding(.bottom)
        }.alert(isPresented: $alertingMessage) {
            Alert(
                title: Text(model.historyDetail),
                message: Text(model.brain.output),
                primaryButton: .default(Text("复制"), action: {
                    UIPasteboard.general.string = model.brain.output
                }),
                secondaryButton: .cancel(Text("取消"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CalculatorModel())
            .previewDevice("iPhone SE (2nd generation)")
    }
}
