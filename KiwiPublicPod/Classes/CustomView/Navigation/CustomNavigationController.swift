//
//  NavigationController.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

/// 自定义导航控制器，统一返回按钮和样式
open class CustomNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    // MARK: - 懒加载返回按钮
    private lazy var backBtn: NavigationBackBtn = {
        let backBtn = NavigationBackBtn(
            frame: CGRect(x: 0, y: 0, width: 44, height: 44),
            img: KiwiPublicPodResource.image(named: "nav-back-btn")!,
            obj: self,
            methord: #selector(backBtnTapped)
        )
        return backBtn
    }()

    // MARK: - 生命周期
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 开启右滑手势返回
        interactivePopGestureRecognizer?.delegate = self

        // 使用自定义导航栏
        setValue(NavigationBar(), forKey: "navigationBar")

        // 外观统一配置
        setAppearance()
    }

    // MARK: - push
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !children.isEmpty {
            // 隐藏底部 TabBar
            viewController.hidesBottomBarWhenPushed = true

            // 自定义返回按钮
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem()
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }

    // MARK: - 返回按钮点击
    @objc private func backBtnTapped() {
        popViewController(animated: true)
    }

    // MARK: - 外观设置
    private func setAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear // 隐藏分隔线

            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            // iOS 14 及以下
            navigationBar.barTintColor = .white
            navigationBar.shadowImage = UIImage() // 隐藏分隔线
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }

        navigationBar.tintColor = .black // 按钮颜色
    }
}

extension CustomNavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.customStatusBarStyle ?? StatusBarManager.shared.style
    }
    
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.customStatusBarHidden ?? StatusBarManager.shared.isHidden
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
