//
//  WidgetViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/9/29.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import KiwiPublicPod

class WidgetViewController: SuperViewController {
    
    // MARK: - =====================lazy load=======================
    private lazy var testView = UIView().backgroundColor(kkColorFromHex("34ab13")).hidden(false).tag(1).border(width: 1, color: .systemRed).cornerRadius(10, corners: [.topLeft,.bottomLeft]).alpha(0.9).clipsToBounds(true).contentMode(.scaleToFill).enable(true).onTap {
        print("testView")
    }
    private lazy var leftView = UIImageView().image(UIImage(named: "setting"))
    private lazy var testField = UITextField().text("").holder("holder").hnFont(size: 22, weight: .regular).centerAligned().color(.systemCyan).borderStyle(.bezel).keyboardType(.decimalPad).returnType(.done).leftView(leftView)
    private lazy var testLabel = UILabel().text("UILabel").color(.systemRed).backgroundColor(.white).minimumScaleFactor(0.5).lines(3).lineBreakMode(.byCharWrapping).adjustsFontSizeToFitWidth(true).centerAligned()
    private lazy var testimageView = UIImageView().image(UIImage(named: "Summary")?.withRenderingMode(.alwaysTemplate)).tintColor(.red)
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
        setUpUI()
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
                
        view.addChildView([testView,testField,testLabel,testimageView])
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
        
        testLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.top.equalTo(testField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        testimageView.snp.makeConstraints { make in
            make.height.width.equalTo(56.h)
            make.left.equalToSuperview().offset(50)
            make.top.equalTo(testLabel.snp.bottom).offset(10)
        }
        
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}


