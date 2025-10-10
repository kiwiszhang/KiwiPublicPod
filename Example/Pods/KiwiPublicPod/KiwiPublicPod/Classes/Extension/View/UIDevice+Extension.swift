//
//  UIDevice+Extension.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/11/4.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import UIKit

/**
 // 判断是否竖屏
 if UIDevice.isPortrait {
     print("竖屏中")
 }

 // 强制切换到横屏
 UIDevice.setCurrentOrientation(.landscapeRight)

 // 强制切换到竖屏
 UIDevice.setCurrentOrientation(.portrait)

 */

public extension UIDevice {
    /// 判断是否竖屏
    static var isPortrait: Bool {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.interfaceOrientation.isPortrait
        }
        return true
    }

    /// 设置当前屏幕方向
    ///
    /// - Parameter orientation: 目标方向（例如 `.portrait`, `.landscapeRight`）
    class func setCurrentOrientation(_ orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

