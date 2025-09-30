//
//  NavigationBar.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

open class NavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isTranslucent = false
        tintColor = .white
        barTintColor = UIColor.white
        shadowImage = UIImage()
            
        titleTextAttributes = [
                                NSAttributedString.Key.foregroundColor: kkColorFromHex("333333"),
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
                                ]
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if kkSystemVersion >= 13.0 {
            for view in subviews {
                if NSStringFromClass(view.classForCoder).contains(str: "_UINavigationBarContentView") {
                    view.frame = CGRect.init(x:-view.layoutMargins.left + 15, y: -view.layoutMargins.top, width: view.layoutMargins.left + view.layoutMargins.right + view.frame.size.width - 30, height: view.layoutMargins.top + view.layoutMargins.bottom + view.frame.size.height)
                }
            }
            return
        }
        if kkSystemVersion >= 11.0 {
            for view in subviews {
                if NSStringFromClass(view.classForCoder).contains(str: "ContentView") {
                    view.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
                }
            }
        }
    }
}
