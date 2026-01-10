//
//  UITextField+Create.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

public extension UITextView {
    // MARK: - 基础属性
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
     
    @discardableResult
    func hnFont(size: CGFloat, weight: InterWeightBase = .regularBase) -> Self {
        self.font = UIFont.interBase(size: size, weight: weight)
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
    func delegate(_ delegate: UITextViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
}

public class PlaceholderTextView: UITextView {

    private let placeholderLabel = UILabel()
    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    public var placeholderColor: UIColor = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    public override var text: String! {
        didSet {
            updatePlaceholderVisibility()
        }
    }

    public override var attributedText: NSAttributedString! {
        didSet {
            updatePlaceholderVisibility()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width
    }

    public func setupPlaceholder() {
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: textContainerInset.top
            ),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: textContainerInset.left + textContainer.lineFragmentPadding
            ),
            placeholderLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -(textContainerInset.right + textContainer.lineFragmentPadding)
            )
        ])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )

        updatePlaceholderVisibility()
    }

    @objc private func textDidChange() {
        updatePlaceholderVisibility()
    }

    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
