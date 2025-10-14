//
//  Widget01ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/10/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget01ViewController: SuperViewController {
//    lazy var comtents = [
//        GuidBannerItem(topImage:Asset.guidStar.image,date: "June 26,2025", title: L10n.helpfulForTaxs, comment: L10n.exportingReportsFor),
//        GuidBannerItem(topImage:Asset.guidStar.image,date: "June 23,2025", title: L10n.efficient, comment: L10n.noMoreManual),
//        GuidBannerItem(topImage:Asset.guidStar.image,date: "June 28,2025", title: L10n.fastAndSimple, comment: L10n.superIntuitive),
//    ]
//    lazy var banner = GuidBannerView(frame: CGRect(x: 0, y: 0, width: kkScreenWidth, height: 112.h),items: comtents).backgroundColor(.clear)
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
        
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------
