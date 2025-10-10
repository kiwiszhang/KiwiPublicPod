//
//  PopupContainerViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/12.
//

import UIKit

open class PopupContainerViewController: SuperViewController {
    private let contentVC: UIViewController
    private let contentHeight: CGFloat
    var onDismiss: (() -> Void)?    // 点击内容内部按钮调用
    private var bottomConstraint: Constraint?   // SnapKit 的约束引用
//    private var panGesture: UIPanGestureRecognizer!

    init(contentVC: UIViewController, height: CGFloat = 300) {
        self.contentVC = contentVC
        self.contentHeight = height
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required public init?(coder: NSCoder) { fatalError() }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // 半透明背景
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        // 点击背景关闭
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        

        // 添加内容控制器
        addChild(contentVC)
        view.addSubview(contentVC.view)
        contentVC.didMove(toParent: self)

        // 用 SnapKit 设置约束
        contentVC.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(contentHeight)
            self.bottomConstraint = make.bottom.equalToSuperview().offset(contentHeight).constraint
        }

        // 圆角
        contentVC.view.layer.cornerRadius = 20
        contentVC.view.layer.masksToBounds = true

        // 添加下拉手势
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        panGesture.delegate = self
//        contentVC.view.addGestureRecognizer(panGesture)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // 判断点击是否在 contentVC.view 外
        if !contentVC.view.frame.contains(location) {
            dismissSelf()
        }
    }

    
    @objc open func dismissSelf() {
        animateOut { [weak self] in
            self?.dismiss(animated: false)
            self?.onDismiss?()
        }
    }

    // MARK: - 动画
    private func animateIn() {
        bottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseOut]) {
            self.view.layoutIfNeeded()
        }
    }

    private func animateOut(completion: @escaping () -> Void) {
        bottomConstraint?.update(offset: contentHeight)
        UIView.animate(withDuration: 0.25,
                       animations: {
                           self.view.layoutIfNeeded()
                           self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                       }, completion: { _ in
                           completion()
                       })
    }

    // MARK: - 下拉手势
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentVC.view)
        let velocity = gesture.velocity(in: contentVC.view)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                bottomConstraint?.update(offset: translation.y)
            }
        case .ended, .cancelled:
            let threshold: CGFloat = 120
            if translation.y > threshold || velocity.y > 1000 {
                dismissSelf() // 下拉超过阈值关闭
            } else {
                // 回到原位
                bottomConstraint?.update(offset: 0)
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
}
