//
//  EmptyView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/20.
//

import UIKit

open class EmptyView: SuperView {
    // MARK: -  =====================lazyload=========================
    private var emptyImg = UIImageView().hidden(false)
    private var emptyLab = UILabel().text("noData").hnFont(size: 16.h, weight: .regularBase).color(kkColorFromHex("B4BBC9")).minimumScaleFactor(0.5).centerAligned()
    // MARK: -  =====================Intial Methods===================
    open override func setUpUI() {
        self.addChildView([emptyImg,emptyLab])
        emptyImg.snp.makeConstraints { make in
            make.width.equalTo(100.w)
            make.height.equalTo(100.w)
            make.center.equalToSuperview()
        }
        emptyLab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(20.h)
            make.top.equalTo(emptyImg.snp.bottom)
        }
        emptyImg.image(KiwiPublicPodResource.image(named: "sunmary_empty"))
    }
    // MARK: -  =======================actions========================
    open func refreshData(emptyImage:UIImage,emptyStr:String){
        emptyImg.image(emptyImage)
        emptyLab.text(emptyStr)
    }
    
    
    // MARK: -  =====================delegate=========================
    
}
