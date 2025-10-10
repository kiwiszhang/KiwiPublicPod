//
//  UIViewController+Extension.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2020/11/3.
//  Copyright © 2020 于晓杰. All rights reserved.
//

import UIKit


private struct AssociatedKeys {
    static var contentViewKey: UInt8 = 0
}

public extension UIViewController {
    var safeTop: ConstraintItem {
        get {
            return view.safeAreaLayoutGuide.snp.top
        }
    }
    var safeBottom: ConstraintItem {
        get {
            return view.safeAreaLayoutGuide.snp.bottom
        }
    }
    var safeLeft: ConstraintItem {
        get {
            return view.safeAreaLayoutGuide.snp.left
        }
    }
    var safeRight: ConstraintItem {
        get {
            return view.safeAreaLayoutGuide.snp.right
        }
    }
    
    private var contentView: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.contentViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.contentViewKey) as? UIView
        }
    }
    
    func hideEmptyView() {
        if contentView != nil {
            contentView?.removeFromSuperview()
            contentView = nil
        }
    }
}
