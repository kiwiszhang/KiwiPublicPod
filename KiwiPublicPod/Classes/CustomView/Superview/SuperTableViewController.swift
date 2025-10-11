//
//  SuperTableViewController.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/4/30.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import Localize_Swift

open class SuperTableViewController: UITableViewController {
    //MARK: ----------懒加载-----------
    private lazy var closeBtn: NavigationBackBtn = {
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setUpUI()
        getData()
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        MyLog("\(NSStringFromClass(self.classForCoder))")
    }
}
//MARK: ----------UI-----------
extension SuperTableViewController {
     @objc open func setUpUI() {
        if navigationController?.viewControllers.first == self && (tabBarController == nil || (tabBarController != nil && tabBarController!.tabBar.isHidden)) && presentingViewController != nil {
            navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: closeBtn), animated: true)
        }
    }
}
//MARK: ----------网络请求-----------
extension SuperTableViewController {
    @objc open func getData() {
        
    }
}
//MARK: ----------其他-----------
extension SuperTableViewController {
    @objc open func closeBtnMethord() {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: ----------切换语言-----------
extension SuperTableViewController {
    @objc open func updateLanguageUI() {
        // 子类重写此方法实现具体更新逻辑
    }
}
