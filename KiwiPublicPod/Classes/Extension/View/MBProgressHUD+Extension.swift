//
//  MBProgressHUD+Extension.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/11/4.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import MBProgressHUD

// 报错解决方法
//https://juejin.cn/post/7523110561312194600

//SDK does not contain 'libarclite' at the path '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphoneos.a'; try increasing the minimum deployment target

extension MBProgressHUD {
    
    /// 只显示文字
    class func showMessage(_ message: String, view: UIView = kkKeyWindow()!) {
        showMessageView(message, imgName: nil, view: view)
    }
    
    /// 成功
    class func showSuccess(_ message: String = "", view: UIView = kkKeyWindow()!) {
        showMessageView(message, imgName: "success", view: view)
    }
    
    /// 失败
    class func showError(_ message: String = "", view: UIView = kkKeyWindow()!) {
        showMessageView(message, imgName: "error", view: view)
    }
    
    /// 警告
    class func showWarning(_ message: String = "", view: UIView = kkKeyWindow()!) {
        showMessageView(message, imgName: "warning", view: view)
    }
    
    /// HUD
    class func showHUD(_ message: String = "", view: UIView = kkKeyWindow()!) {
        showHUDView(message, view: view)
    }
    
    /// 进度
    class func showProgress(_ message: String = "", view: UIView = kkKeyWindow()!) -> MBProgressHUD? {
        return showProgressView(message, view: view)
    }
    
    /// 隐藏
    class func hideHUD(_ view: UIView = kkKeyWindow()!) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

// MARK: - Private
extension MBProgressHUD {
    
    private class func showMessageView(_ text: String?, imgName: String?, view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.detailsLabel.text = text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        
        if let imgName = imgName {
            hud.customView = UIImageView(image: UIImage(named: "MBProgressHUD.bundle/\(imgName)"))
            hud.mode = .customView
        } else {
            hud.mode = .text
        }
        
        hud.hide(animated: true, afterDelay: 2)
    }
    
    private class func showHUDView(_ text: String?, view: UIView) {
        if MBProgressHUD(view: view) != nil { return }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.detailsLabel.text = text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        hud.removeFromSuperViewOnHide = true
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = .clear
    }
    
    private class func showProgressView(_ text: String?, view: UIView) -> MBProgressHUD? {
        if MBProgressHUD(view: view) != nil { return nil }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = text
        hud.label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        hud.mode = .determinate
        hud.removeFromSuperViewOnHide = true
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = .clear
        return hud
    }
}
