//
//  CalculatorModel.swift
//  Calculator
//
//  Created by jingpeng.hu on 2021/1/19.
//

import Foundation

// ObservableObject 协议要求实现类型是 class，它只有一个需要实现的属性，objectWillChange。
// 在数据将要发生改变时，这个属性用来向外进行“广播”，它的订阅者（一般是 View 相关的逻辑）在收到通知后，对 View 进行刷新。
// 创建 ObservableObject 后，实际在 View 里使用时，我们需要将它声明为 @ObservedObject。这个也是一个属性包装，它负责通过订阅 objectWillChange 这个“广播”，将具体管理数据的 ObservableObject 和当前的 View 关联起来
class CalculatorModel: ObservableObject {
    @Published var brain: CalculatorBrain = .left("0")
    // 为实现回溯操作
    @Published var history: [CalculatorButtonItem] = []
    
    func apply(item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    // historyDetail 将 history 数组中所纪录的操作步骤的描述连接起来，作为履历的输出字符串
    var historyDetail: String {
        history.map { $0.description }.joined()
    }
    
    // 在回溯操作时，除了维护 history 并让 historyDetail 反映当前的历史步骤的同时，我们也希望保留那些“被回溯”的操作，这样我们还能使用滑块恢复这些操作。用 temporaryKept 来暂存这些操作
    var temporaryKept: [CalculatorButtonItem] = []
    
    // 滑块的最大值应当是 history 和 temporaryKept 两个数组元素数量的和
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    // 使用 slidingIndex 表示当前滑块表示的 index 值，这个值应该是 0 到 totalCount 之间的一个数字。事实上我们应该选用 Int 作为 slidingIndex 的类型，但是 SwiftUI 中代表滑块的 Slider 只接受浮点数的值。我们想要将 model 的这个属性绑定到 UI 上，需要有符合的类型。
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    // 根据 index 把 history 和 temporaryKept 的元素重新分配。然后根据 history 重新计算当前 brain 的状态。
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        history = Array(total[..<index])
        temporaryKept = Array(total[..<index])
        
        brain = history.reduce(CalculatorBrain.left("0")) { result, item in
            result.apply(item: item)
        }
    }
}
