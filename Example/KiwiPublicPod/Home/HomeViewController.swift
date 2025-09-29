//
//  HomeViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/9/29.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import KiwiPublicPod

class HomeViewController: SuperViewController {
    
    private lazy var testView = UIView().backgroundColor(kkColorFromHex("34ab13")).hidden(false).tag(1).border(width: 1, color: .systemRed).cornerRadius(10, corners: [.topLeft,.bottomLeft]).alpha(0.9).clipsToBounds(true).contentMode(.scaleToFill).enable(true).onTap {
        print("testView")
    }
    private lazy var leftView = UIView().backgroundColor(.systemPink)
    private lazy var testField = UITextField().text("").holder("holder").hnFont(size: 22, weight: .regular).centerAligned().color(.systemCyan).borderStyle(.bezel).keyboardType(.decimalPad).returnType(.done).leftView(leftView)
    // MARK: - =====================life cycle=======================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "首页"
        setUpUI()
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        view.addChildView([testView,testField])
        testView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        testField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.top.equalTo(testView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    override func getData() {

    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBarManager.shared.style
    }
}

extension HomeViewController {
    override var prefersStatusBarHidden: Bool {
        return StatusBarManager.shared.isHidden
    }
}
