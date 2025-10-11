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
    var paddingSpace: CGFloat = 0
    var customBtnType: CustomButtonType = .Left {
        didSet {
            layoutIfNeeded()
        }
    }
    var newSize = CGSize()
}

//MARK: ----------系统方法-----------
public extension CustomButton {
    override var frame: CGRect {
        didSet {
            layoutIfNeeded()
        }
    }
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        layoutIfNeeded()
    }
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        layoutIfNeeded()
    }
    override func sizeToFit() {
        super.sizeToFit()
        layoutSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let customTitleLabel = titleLabel else { return }
        guard let customImageView = imageView else { return }
        
        titleLabel?.height = customTitleLabel.height == 0 ? UILabel.labHeight(customTitleLabel.text ?? "", font: customTitleLabel.font, width: width) : customTitleLabel.height
        titleLabel?.width = UILabel.labWidth(titleLabel!.text ?? "", font: titleLabel!.font)
        
        let imgRote = (customImageView.image?.size.height ?? 0) / (customImageView.image?.size.width ?? 1)
        
        switch customBtnType {
        case .Right:
            let newImageWidth = customImageView.height / imgRote
            imageView?.width = newImageWidth
            let leftSpace = max((width - customTitleLabel.width - newImageWidth - paddingSpace) / 2.0, 0)
            
            //文字
            titleLabel?.left = leftSpace
            titleLabel?.top = customTitleLabel.top
            
            //图片
            imageView?.left = customTitleLabel.width + leftSpace + paddingSpace
            imageView?.top = (height - customImageView.height) / 2.0
            
            newSize = CGSize.init(width: customTitleLabel.width + paddingSpace + newImageWidth, height: height)
        case .Up:
            titleLabel?.textAlignment = .center;
            
            let newImageHeight = customImageView.width * imgRote
            imageView?.height = newImageHeight
            let topSpace = max((height - customTitleLabel.height - newImageHeight - paddingSpace), 0)
            
            //图片
            imageView?.top = topSpace
            imageView?.left = (width - customImageView.width) / 2.0
            
            //文字
            titleLabel?.left = 0
            titleLabel?.width = width
            titleLabel?.top = newImageHeight + topSpace + paddingSpace
            
            newSize = CGSize.init(width: width, height: newImageHeight + paddingSpace + customTitleLabel.height)
        case .Down:
            titleLabel?.textAlignment = .center;
            
            let newImageHeight = customImageView.width * imgRote
            imageView?.height = newImageHeight
            let topSpace = max((height - customTitleLabel.height - newImageHeight - paddingSpace), 0)
            
            //文字
            titleLabel?.left = 0
            titleLabel?.width = width
            titleLabel?.top = topSpace
            
            //图片
            imageView?.left = (width - customImageView.width) / 2.0
            imageView?.top = paddingSpace + customTitleLabel.height + topSpace
            
            newSize = CGSize.init(width: width, height: newImageHeight + paddingSpace + customTitleLabel.height)
        default:
            let newImageWidth = customImageView.height / imgRote
            imageView?.width = newImageWidth
            let leftSpace = max((width - customTitleLabel.width - newImageWidth - paddingSpace) / 2.0, 0)
            
            //图片
            imageView?.left = leftSpace
            imageView?.top = (height - customImageView.height) / 2.0
            
            //文字
            titleLabel?.left = newImageWidth + leftSpace + paddingSpace
            titleLabel?.top = customTitleLabel.top
            
            newSize = CGSize.init(width: customTitleLabel.width + paddingSpace + newImageWidth, height: height)
        }
    }
}

