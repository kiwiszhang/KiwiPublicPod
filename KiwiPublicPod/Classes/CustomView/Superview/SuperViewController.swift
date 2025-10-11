//
//  SuperViewController.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/4/30.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import Localize_Swift

open class SuperViewController: UIViewController {
    //MARK: ----------懒加载-----------
    private lazy var closeBtn : NavigationBackBtn = {
        let closeBtn = NavigationBackBtn.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44), obj: self, methord: #selector(closeBtnMethord))
        return closeBtn
    }()
    //MARK: ----------系统方法-----------
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setUpUI()
        getData()
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        MyLog("\(NSStringFromClass(self.classForCoder)) 释放")
    }
}
//MARK: ----------UI-----------
extension SuperViewController {
    @objc open func setUpUI() {
        if navigationController?.viewControllers.first == self && (tabBarController == nil || (tabBarController != nil && tabBarController!.tabBar.isHidden)) && presentingViewController != nil {
            navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: closeBtn), animated: true)
        }
        if #available(iOS 11.0, *) {
            for subView in view.subviews {
                if subView.isKind(of: UIScrollView.classForCoder()) {
                    let scrollerView = subView as! UIScrollView
                    scrollerView.contentInsetAdjustmentBehavior = .never
                }
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension SuperViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBarManager.shared.style
    }

    open override var prefersStatusBarHidden: Bool {
        return StatusBarManager.shared.isHidden
    }
}
//MARK: ----------网络请求-----------
extension SuperViewController {
    @objc open func getData() {
        
    }
}
//MARK: ----------其他-----------
extension SuperViewController {
    @objc open func closeBtnMethord() {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: ----------切换语言-----------
extension SuperViewController {
    @objc open func updateLanguageUI() {
        // 子类重写此方法实现具体更新逻辑
    }
}

