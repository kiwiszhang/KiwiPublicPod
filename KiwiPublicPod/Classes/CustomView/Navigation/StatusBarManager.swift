//
//  StatusBarManager.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/24.
//
import UIKit

//let modalVC = UIViewController()
//modalVC.modalPresentationStyle = .fullScreen
//// 临时白色状态栏
//StatusBarManager.shared.applyTemporary(style: .lightContent, hidden: false)
//// 手势返回或拖拽关闭后自动恢复
//modalVC.setupStatusBarRestoreOnDismiss()
//present(modalVC, animated: true)

open class StatusBarManager {
    static public let shared = StatusBarManager()
    
    /// 状态栏是否隐藏
    public var isHidden: Bool = false
    
    /// 状态栏文字样式
    public var style: UIStatusBarStyle = .darkContent
    
    /// 临时存储上一次状态栏样式，用于恢复
    private var previousStyle: UIStatusBarStyle?
    private var previousHidden: Bool?
    
    private init() {}
    
    /// 应用临时状态栏样式
    public func applyTemporary(style: UIStatusBarStyle, hidden: Bool) {
        previousStyle = self.style
        previousHidden = self.isHidden
        self.style = style
        self.isHidden = hidden
        updateStatusBar()
    }
    
    /// 恢复之前状态栏样式
    public func restorePrevious() {
        if let prevStyle = previousStyle, let prevHidden = previousHidden {
            self.style = prevStyle
            self.isHidden = prevHidden
            previousStyle = nil
            previousHidden = nil
            updateStatusBar()
        }
    }
    
    /// 刷新状态栏
    public func updateStatusBar() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows.first else { return }
            window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}


import UIKit
import ObjectiveC

private var statusBarStyleKey: UInt8 = 0
private var statusBarHiddenKey: UInt8 = 0

extension UIViewController {
    
    public var customStatusBarStyle: UIStatusBarStyle? {
        get { objc_getAssociatedObject(self, &statusBarStyleKey) as? UIStatusBarStyle }
        set { objc_setAssociatedObject(self, &statusBarStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var customStatusBarHidden: Bool? {
        get { objc_getAssociatedObject(self, &statusBarHiddenKey) as? Bool }
        set { objc_setAssociatedObject(self, &statusBarHiddenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 模态页面拖拽消失或者 Push 手势返回时自动恢复状态栏
    public func setupStatusBarRestoreOnDismiss() {
        if let nav = self.navigationController, nav.viewControllers.first != self {
            nav.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture))
        }
        if let sheet = self.presentationController as? UISheetPresentationController {
            sheet.delegate = self
        }
    }
    
    @objc private func handlePopGesture(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            StatusBarManager.shared.restorePrevious()
        }
    }
}

extension UIViewController: @retroactive UIAdaptivePresentationControllerDelegate {}
extension UIViewController: @retroactive UISheetPresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        StatusBarManager.shared.restorePrevious()
    }
}

