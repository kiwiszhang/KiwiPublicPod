//
//  UINavigationItem+Extension.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

private struct BarKeys {
    static var leftBarKey: UInt8 = 0
    static var rightBarKey: UInt8 = 0
}

public extension UINavigationItem {
    var leftBarButtonItem: UIBarButtonItem {
        set(value) {
            objc_setAssociatedObject(self, &BarKeys.leftBarKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            leftBarButtonItems = [spaceItem(space: -7), value]
        }
        get {
            return objc_getAssociatedObject(self, &BarKeys.leftBarKey) as! UIBarButtonItem
        }
    }
    var rightBarButtonItem: UIBarButtonItem {
        set(value) {
            objc_setAssociatedObject(self, &BarKeys
                .rightBarKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            rightBarButtonItems = [spaceItem(space: -7), value]
        }
        get {
            return objc_getAssociatedObject(self, &BarKeys
                .rightBarKey) as! UIBarButtonItem
        }
    }
    //MARK: ----------其他-----------
    private func spaceItem(space: CGFloat) -> UIBarButtonItem {
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = space
        return spaceItem
    }
}
//MARK: ----------RunTimeProtocol-----------
extension UINavigationItem: RunTimeProtocol {
    static public func appAwake() {
        swizzleMethod
    }
    private static let swizzleMethod: Void = {
        if (kkSystemVersion < 11.0) {
            let originalLeftSelector = #selector(setLeftBarButton(_:animated:))
            let swizzledLeftSelector = #selector(custom_setLeftBarButtonItem(item:animated:))
            method_exchangeImplementations(class_getInstanceMethod(UINavigationItem.self, originalLeftSelector)!, class_getInstanceMethod(UINavigationItem.self, swizzledLeftSelector)!)
            
            let originalRightSelector = #selector(setRightBarButton(_:animated:))
            let swizzledRightSelector = #selector(custom_setRightBarButtonItem(item:animated:))
            method_exchangeImplementations(class_getInstanceMethod(UINavigationItem.self, originalRightSelector)!, class_getInstanceMethod(UINavigationItem.self, swizzledRightSelector)!)
        }
    }()

    @objc private func custom_setLeftBarButtonItem(item: UIBarButtonItem, animated: Bool) {
        setLeftBarButtonItems([spaceItem(space: -7), item], animated: animated)
    }
    @objc private func custom_setRightBarButtonItem(item: UIBarButtonItem, animated: Bool) {
        setRightBarButtonItems([spaceItem(space: -7), item], animated: animated)
    }
}
