//
//  UIView+Extension.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

//MARK: ----------坐标尺寸-----------
public extension UIView {
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    var right: CGFloat {
        get {
            return self.left + self.width
        }
    }
    var bottom: CGFloat {
        get {
            return self.top + self.height
        }
    }
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newSize) {
            var frame = self.frame
            frame.size.width = newSize.width
            frame.size.height = newSize.height
            self.frame = frame
        }
    }
    
    // 递归查找所有子视图
    // let gradientViews = findAllSubviews(in: currentWindow!).compactMap { $0 as? GradientCircelView }
    func findAllSubviews(in view: UIView) -> [UIView] {
        var subviews = view.subviews
        for subview in view.subviews {
            subviews += findAllSubviews(in: subview)
        }
        return subviews
    }
}

// MARK: - 数据
public extension UIView {
    // 渐变方向枚举
    enum GradientDirection {
        case none // 渐变色边框
        case leftToRight      // 从左到右
        case rightToLeft      // 从右到左
        case topToBottom      // 从上到下
        case bottomToTop      // 从下到上
        case topLeftToBottomRight   // 左上到右下
        case topRightToBottomLeft   // 右上到左下
        case bottomRightToTopLeft   // 右下到左上
        case bottomLeftToTopRight   // 左下到右上
    }
    
    static func gradientPoints(direction: GradientDirection) -> (start: CGPoint, end: CGPoint) {
        switch direction {
        case .none:
            return (CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.5, y: 0.5))
        case .leftToRight:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .rightToLeft:
            return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5))
        case .topToBottom:
            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        case .bottomToTop:
            return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0))
        case .topLeftToBottomRight:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
        case .topRightToBottomLeft:
            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        case .bottomRightToTopLeft:
            return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0))
        case .bottomLeftToTopRight:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        }
    }
    
    // 渐变色类型
    private enum GradientType {
        case background(cornerRadius: CGFloat)
        case border(lineWidth: CGFloat, cornerRadius: CGFloat)
    }
    
    // 渐变色配置存储
    private struct GradientConfig {
        let colors: [UIColor]
        let locations: [CGFloat]?
        let direction: GradientDirection
        let type: GradientType
    }
    
    // 投影存储
    private struct ShadowConfig {
        let color: UIColor
        let radius: CGFloat
        let opacity: Float
        let offset: CGSize
        let cornerRadius: CGFloat?
    }
    
    private struct AssociatedKeys {
        static var gradientConfig: UInt8 = 0
        static var gradientObserver: UInt8 = 0
        static var shadowConfig: UInt8 = 0
        static var shadowObserver: UInt8 = 0
    }
    
    private var gradientConfig: GradientConfig? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.gradientConfig) as? GradientConfig }
        set { objc_setAssociatedObject(self, &AssociatedKeys.gradientConfig, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    private var shadowConfig: ShadowConfig? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.shadowConfig) as? ShadowConfig }
        set { objc_setAssociatedObject(self, &AssociatedKeys.shadowConfig, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

// MARK: - 渐变色
public extension UIView {
    // MARK: - 渐变色背景
    func addGradientBackground(colors: [UIColor],
                               locations: [CGFloat]? = nil,
                               cornerRadius: CGFloat = 0,
                               direction: GradientDirection) {
        let config = GradientConfig(
            colors: colors,
            locations: locations,
            direction: direction,
            type: .background(cornerRadius: cornerRadius)
        )
        applyGradient(config: config)
    }
    
    // MARK: - 渐变色边框
    func addGradientBorder(colors: [UIColor],
                           lineWidth: CGFloat,
                           cornerRadius: CGFloat) {
        let config = GradientConfig(
            colors: colors,
            locations: nil,
            direction: .none,
            type: .border(lineWidth: lineWidth, cornerRadius: cornerRadius)
        )
        applyGradient(config: config)
    }
    
    // MARK: - 移除渐变色
    func removeGradient() {
        layer.sublayers?
            .filter { $0.name == "GradientLayer" }
            .forEach { $0.removeFromSuperlayer() }
        
        if let observer = objc_getAssociatedObject(self, &AssociatedKeys.gradientObserver) as? NSKeyValueObservation {
            observer.invalidate()
        }
        
        gradientConfig = nil
    }
    
    private func applyGradient(config: GradientConfig) {
        // 1. 移除旧渐变色
        removeGradient()
        
        // 2. 存储配置
        gradientConfig = config
        
        // 3. 创建并应用渐变色
        updateGradient()
        
        // 4. 监听尺寸变化
        setupBoundsObserver()
    }
    
    private func updateGradient() {
        layer.sublayers?
            .filter { $0.name == "GradientLayer" }
            .forEach { $0.removeFromSuperlayer() }
        
        guard let config = gradientConfig else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientLayer"
        gradientLayer.colors = config.colors.map { $0.cgColor }
        gradientLayer.locations = config.locations?.map { NSNumber(value: Double($0)) }
        
        // 设置渐变方向
        switch config.direction {
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
        
        // 处理背景或边框
        switch config.type {
        case .background(let cornerRadius):
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
            
        case .border(let lineWidth, let cornerRadius):
            gradientLayer.frame = bounds
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = lineWidth
            shapeLayer.path = UIBezierPath(
                roundedRect: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2),
                cornerRadius: cornerRadius
            ).cgPath
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.white.cgColor
            
            gradientLayer.mask = shapeLayer
            layer.addSublayer(gradientLayer)
        }
    }
    
    private func setupBoundsObserver() {
        let observer = observe(\.bounds) { [weak self] _, _ in
            self?.updateGradient()
        }
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.gradientObserver,
            observer,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
}

// MARK: - 投影
public extension UIView {
    func addShadow(
        _ color: UIColor,
        _ radius: CGFloat,
        _ opacity: Float,
        _ wSet: CGFloat,
        _ hSet: CGFloat,
        _ cornerRadius: CGFloat? = nil
    ) {
        clipsToBounds = false
        layer.masksToBounds = false
        
        // 存储配置参数
        let config = ShadowConfig(
            color: color,
            radius: radius,
            opacity: opacity,
            offset: CGSize(width: wSet, height: hSet),
            cornerRadius: cornerRadius
        )
        shadowConfig = config
        
        updateShadow()
        
        setupSizeObserver()
    }
    
    /// 更新阴影效果
    private func updateShadow() {
        guard let config = shadowConfig, bounds != .zero else { return }
        
        layer.shadowColor = config.color.cgColor
        layer.shadowRadius = config.radius
        layer.shadowOpacity = config.opacity
        layer.shadowOffset = config.offset
        
        // 动态圆角处理
        let effectiveCornerRadius = config.cornerRadius ?? layer.cornerRadius
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: effectiveCornerRadius
        ).cgPath
    }
    
    private func setupSizeObserver() {
        let observer = observe(\.bounds) { [weak self] _, _ in
            self?.updateShadow()
        }
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.shadowObserver,
            observer,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
}
