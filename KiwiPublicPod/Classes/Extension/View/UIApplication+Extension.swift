//
//  111.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/3/31.
//

import Foundation

public extension UIApplication {
    static var topWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .max(by: { $0.windowLevel.rawValue < $1.windowLevel.rawValue })
        } else {
            return UIApplication.shared.windows.max(by: {
                $0.windowLevel.rawValue < $1.windowLevel.rawValue
            })
        }
    }
    
    /// 获取当前显示的ViewController
    class func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? shared.windows.first { $0.isKeyWindow }?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

