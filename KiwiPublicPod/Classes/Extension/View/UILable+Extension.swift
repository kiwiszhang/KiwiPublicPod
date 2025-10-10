//
//  UILable+Extension.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

public extension UILabel {
    func addGradient(colors: [UIColor], direction: GradientDirection = .leftToRight) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        // 设置渐变方向
        switch direction {
        case .none:
            break
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .topRightToBottomLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottomRightToTopLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        case .bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        
        // 转换为文字颜色
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            if let gradientImage = UIGraphicsGetImageFromCurrentImageContext() {
                self.textColor = UIColor(patternImage: gradientImage)
            }
        }
    }
}

//MARK: ----------创建方法-----------
public extension UILabel {
    /// 倒计时按钮
    ///
    /// - Parameters:
    ///   - title: 重置标题
    ///   - waitTime: 等待时间
    func startLab(title: String, waitTitle: String) {
        var timeOut = 60
        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler {
            if timeOut <= 0 {
                timer.cancel()
                DispatchQueue.main.sync(execute: {
                    self.enable(true).text(title)
                })
            } else {
                DispatchQueue.main.sync(execute: {
                    timeOut -= 1
                    let seconds = timeOut % 60
                    self.enable(true).text("\(seconds)\(waitTitle)")
                })
            }
        }
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.resume()
    }
    
    /// Lab高度
    ///
    /// - Parameters:
    ///   - title: 文本内容
    ///   - font: 文本大小
    ///   - width: 文本宽度
    /// - Returns: Lab高度
    class func labHeight(_ title: String, font: UIFont, width: CGFloat) -> CGFloat {
        return (title as NSString).boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).height
    }
    
    /// Lab宽度
    ///
    /// - Parameters:
    ///   - title: 文本内容
    ///   - font: 文本大小
    /// - Returns: 文本宽度
    class func labWidth(_ title: String, font: UIFont) -> CGFloat {
        return (title as NSString).boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).width
    }
}
