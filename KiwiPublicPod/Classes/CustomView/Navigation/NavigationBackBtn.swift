//
//  NavigationBackBtn.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

open class NavigationBackBtn: UIButton {
    //MARK: ----------懒加载-----------
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    //MARK: ----------初始化-----------
    init(frame: CGRect, img: UIImage = KiwiPublicPodResource.image(named: "nav-back-btn")!, obj: AnyObject?, methord: Selector?) {
        super.init(frame: frame)
        
        imgView.image = img
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(17.7)
        }
        if methord != nil {
            addTarget(obj, action: methord!, for: .touchUpInside)
        }
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
