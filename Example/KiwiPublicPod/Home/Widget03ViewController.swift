//
//  Widget02ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/11/4.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget03ViewController: SuperViewController {
    
    // MARK: - =====================lazy load=======================

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
        
        // 1. 创建按钮数组
        var buttonArray: [UIButton] = []
        for i in 1...19 {
            let btn = UIButton()
            btn.setTitle("\(i)", for: .normal)
            btn.backgroundColor = .systemBlue
            btn.layer.cornerRadius = 8
            buttonArray.append(btn)
        }

        // 2. 初始化 CustomNineGirdView
        let nineGird = CustomNineGirdView(
            viewArray: buttonArray,
            nineGirdWidth: kkScreenWidth - 40.w,   // 九宫格总宽度
            itemHeight: (80.w, true),                // item高度固定 80
            colums: 3,                              // 每行 3 列
            HMargin: 10.h,                            // 水平间距 10
            VMargin: 10.w                             // 垂直间距 10
        )

        
        // 3. 添加到父视图
        view.addSubview(nineGird)
        nineGird.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(nineGird.nineGirdViewHeight) // 使用计算出的高度
        }
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================
   
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}
