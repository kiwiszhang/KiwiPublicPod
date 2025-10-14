//
//  ReportViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/10/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class ReportViewController: SuperViewController {
    
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
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        title = "报告"
        view.backgroundColor(.white)
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------

