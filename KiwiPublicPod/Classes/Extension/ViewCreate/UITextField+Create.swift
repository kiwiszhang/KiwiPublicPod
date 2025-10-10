//
//  UITextField+Create.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

public extension UITextField {
    // MARK: - 基础属性
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func holder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
     
    @discardableResult
    func hnFont(size: CGFloat, weight: InterWeight = .regular) -> Self {
        self.font = UIFont.inter(size: size, weight: weight)
        return self
    }
    
    @discardableResult
    func fontSize(_ fontSize: UIFont) -> Self {
        self.font = fontSize
        return self
    }
    
    @discardableResult
    func centerAligned() -> Self {
        textAlignment = .center
        return self
    }
    
    @discardableResult
    func leftAligned() -> Self {
        textAlignment = .left
        return self
    }
    
    @discardableResult
    func rightAligned() -> Self {
        textAlignment = .right
        return self
    }
    
    @discardableResult
    func color(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    // MARK: - 布局相关
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        self.borderStyle = style
        return self
    }
    
    // MARK: - 高级功能
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }
    
    @discardableResult
    func returnType(_ type: UIReturnKeyType) -> Self {
        self.returnKeyType = type
        return self
    }
    
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func leftView(_ view: UIView?, mode: UITextField.ViewMode = .always) -> Self {
        self.leftView = view
        self.leftViewMode = mode
        return self
    }
    
    @discardableResult
    func rightView(_ view: UIView?, mode: UITextField.ViewMode = .always) -> Self {
        self.rightView = view
        self.rightViewMode = mode
        return self
    }
}
