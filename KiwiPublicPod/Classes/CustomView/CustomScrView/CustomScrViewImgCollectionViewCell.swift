//
//  CustomScrViewImgCollectionViewCell.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/17.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class CustomScrViewImgCollectionViewCell: SuperCollectionViewCell {
    var imgName: String? {
        didSet {
            if imgName != nil {
                if imgName!.contains(str: "http") {
                    if let imgURLStr = URL.init(string: imgName!) {
//                        imgView.kf.setImage(with: imgURLStr, placeholder: UIImage.init(named: "AppIcon"))
                    } else {
                        imgView.image = UIImage.init(named: "AppIcon")
                    }
                } else {
                    imgView.image = UIImage.init(named: imgName!)
                }
            }
        }
    }
    //MARK: ----------懒加载-----------
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()

    override func setUpUI() {
        super.setUpUI()
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: ----------其他-----------
extension CustomScrViewImgCollectionViewCell {
    func upDateStartBtn(_ btn: UIButton?, btnFrame: CGRect?) {
        if btn != nil && btnFrame != nil {
            addSubview(btn!)
            btn!.snp.makeConstraints({ (make) in
                make.height.equalTo(btnFrame!.size.height)
                make.top.equalToSuperview().offset(btnFrame!.origin.y)
                make.centerX.equalToSuperview()
                make.width.equalTo(btnFrame!.size.width)
            })
        }
    }
}
