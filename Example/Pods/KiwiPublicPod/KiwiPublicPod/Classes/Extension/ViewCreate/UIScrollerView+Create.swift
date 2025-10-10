//
//  UIScrollerView+Create.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/10/28.
//  Copyright © 2019 于晓杰. All rights reserved.
//
import UIKit

public extension UIScrollView {
    // MARK: - 基础配置
    @discardableResult
    func scrollEnable(_ enabled: Bool) -> Self {
        isScrollEnabled = enabled
        return self
    }
    
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    // MARK: - 滚动行为
    /// 设置边界回弹效果
    @discardableResult
    func bounces(_ enabled: Bool) -> Self {
        bounces = enabled
        return self
    }
    
    /// 设置垂直方向回弹
    @discardableResult
    func bouncesV(_ enabled: Bool) -> Self {
        alwaysBounceVertical = enabled
        return self
    }
    
    /// 设置水平方向回弹
    @discardableResult
    func bouncesH(_ enabled: Bool) -> Self {
        alwaysBounceHorizontal = enabled
        return self
    }
    
    /// 设置垂直滚动条可见性
    @discardableResult
    func showsV(_ show: Bool) -> Self {
        showsVerticalScrollIndicator = show
        return self
    }
    
    /// 设置水平滚动条可见性
    @discardableResult
    func showsH(_ show: Bool) -> Self {
        showsHorizontalScrollIndicator = show
        return self
    }
    
    /// 同时设置水平和垂直滚动条可见性
    @discardableResult
    func showsHV(_ show: Bool) -> Self {
        showsVerticalScrollIndicator = show
        showsHorizontalScrollIndicator = show
        return self
    }
    
    // MARK: - 内容布局
    /// 设置内容边距
    @discardableResult
    func inset(_ insets: UIEdgeInsets) -> Self {
        contentInset = insets
        return self
    }
    
    /// 设置初始滚动偏移量（对应 `contentOffset`）
    /// - 典型场景：初始化时定位到指定位置
    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }
    
    /// 设置内容区域大小（对应 `contentSize`）
    /// - 关键：必须大于 scrollView 的 bounds 才能滚动
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        contentSize = size
        return self
    }
    
    // MARK: - 缩放配置
    /// 设置最小缩放比例
    @discardableResult
    func minScale(_ scale: CGFloat) -> Self {
        minimumZoomScale = scale
        return self
    }
    
    /// 设置最大缩放比例
    @discardableResult
    func maxScale(_ scale: CGFloat) -> Self {
        maximumZoomScale = scale
        return self
    }
    
    /// 设置当前缩放比例
    @discardableResult
    func zoomScale(_ scale: CGFloat) -> Self {
        zoomScale = scale
        return self
    }
    
    /// 设置缩放时是否允许回弹
    @discardableResult
    func bouncesZoom(_ enabled: Bool) -> Self {
        bouncesZoom = enabled
        return self
    }
    
    // MARK: - 滚动条样式
    
    /// 设置滚动条样式
    /// - 可选值：`.default`/`.black`/`.white`
    @discardableResult
    func lineStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = style
        return self
    }
    
    /// 设置滚动条边距
    /// - 特殊场景：与自定义浮动按钮布局冲突时调整
    @discardableResult
    func lineInsets(_ insets: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = insets
        return self
    }
    
    // MARK: - 分页/方向
    /// 启用分页滚动（对应 `isPagingEnabled`）
    /// - 典型场景：轮播图/相册翻页
    @discardableResult
    func pageEnable(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }
    
    /// 启用方向锁定（对应 `isDirectionalLockEnabled`）
    /// - 作用：优先识别单一方向滚动（避免斜向滚动）
    @discardableResult
    func lockDirection(_ enabled: Bool) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }
    
    // MARK: - 键盘交互
    @discardableResult
    func keyboardMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }
}
