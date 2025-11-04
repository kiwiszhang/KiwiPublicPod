//
//  CustomButton.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/20.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

public enum CustomButtonType: String {
    case Left = "Left"
    case Right = "Right"
    case Up = "Up"
    case Down = "Down"
}

open class CustomButton: UIButton {

    // MARK: - 公共属性
    public var paddingSpace: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public var customBtnType: CustomButtonType = .Left {
        didSet { setNeedsLayout() }
    }

    public private(set) var newSize = CGSize.zero

    // MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // 禁用 UIButtonConfiguration，保证 imageView / titleLabel 不为 nil
        if #available(iOS 15.0, *) {
            self.configuration = nil
        }
        // iOS 14 及以下
        self.adjustsImageWhenHighlighted = false
    }

    // MARK: - layout
    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let titleLabel = titleLabel, let imageView = imageView, let image = imageView.image else {
            // 没有图片不布局
            return
        }

        titleLabel.sizeToFit()
        let titleSize = titleLabel.bounds.size

        // 根据 image 宽高比计算图片显示尺寸
        let imgRatio = image.size.width > 0 ? image.size.height / image.size.width : 1
        let imageWidth = imageView.frame.width > 0 ? imageView.frame.width : height / imgRatio
        let imageHeight = imageWidth * imgRatio

        switch customBtnType {
        case .Left:
            imageView.frame = CGRect(
                x: (width - imageWidth - titleSize.width - paddingSpace) / 2,
                y: (height - imageHeight) / 2,
                width: imageWidth,
                height: imageHeight
            )
            titleLabel.frame = CGRect(
                x: imageView.frame.maxX + paddingSpace,
                y: (height - titleSize.height) / 2,
                width: titleSize.width,
                height: titleSize.height
            )
        case .Right:
            titleLabel.frame = CGRect(
                x: (width - imageWidth - titleSize.width - paddingSpace) / 2,
                y: (height - titleSize.height) / 2,
                width: titleSize.width,
                height: titleSize.height
            )
            imageView.frame = CGRect(
                x: titleLabel.frame.maxX + paddingSpace,
                y: (height - imageHeight) / 2,
                width: imageWidth,
                height: imageHeight
            )
        case .Up:
            let totalHeight = imageHeight + paddingSpace + titleSize.height
            imageView.frame = CGRect(
                x: (width - imageWidth) / 2,
                y: (height - totalHeight) / 2,
                width: imageWidth,
                height: imageHeight
            )
            titleLabel.frame = CGRect(
                x: 0,
                y: imageView.frame.maxY + paddingSpace,
                width: width,
                height: titleSize.height
            )
            titleLabel.textAlignment = .center
        case .Down:
            let totalHeight = imageHeight + paddingSpace + titleSize.height
            titleLabel.frame = CGRect(
                x: 0,
                y: (height - totalHeight) / 2,
                width: width,
                height: titleSize.height
            )
            imageView.frame = CGRect(
                x: (width - imageWidth) / 2,
                y: titleLabel.frame.maxY + paddingSpace,
                width: imageWidth,
                height: imageHeight
            )
            titleLabel.textAlignment = .center
        }

        // 保存计算后的尺寸
        newSize = CGSize(
            width: max(titleLabel.frame.maxX, imageView.frame.maxX),
            height: max(titleLabel.frame.maxY, imageView.frame.maxY)
        )
    }

    // MARK: - 禁止点击变灰
    open override var isHighlighted: Bool {
        didSet {
            // 空实现，点击不变灰
        }
    }
}
