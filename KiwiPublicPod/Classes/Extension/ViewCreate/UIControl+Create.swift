//
//  UIControl+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/5.
//

import UIKit

// MARK: - 闭包封装工具类（解决循环引用）
private class ControlClosureWrapper {
    let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc public func invoke() {
        closure()
    }
}

public extension UIControl {
    private struct AssociatedKeys {
        static var actionClosureKey: UInt8 = 0
    }
    
    /// 存储闭包的关联对象
    private var actionClosure: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionClosureKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.actionClosureKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /// 绑定点击事件
    @discardableResult
    func onClick(eventType:UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) -> Self {
        if #available(iOS 14.0, *) {
            // iOS 14+ 使用 UIAction 包裹闭包
            addAction(UIAction { _ in closure() }, for: .touchUpInside)
        } else {
            // iOS 13 使用关联对象 + 动态调用
            let wrapper = ControlClosureWrapper(closure)
            actionClosure = closure // 保留闭包引用
            addTarget(wrapper, action: #selector(ControlClosureWrapper.invoke), for: eventType)
            
            // 关键：将 wrapper 也关联到按钮，避免提前释放
            objc_setAssociatedObject(
                self,
                "\(UUID())", // 随机 key 避免冲突
                wrapper,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        return self
    }
}
