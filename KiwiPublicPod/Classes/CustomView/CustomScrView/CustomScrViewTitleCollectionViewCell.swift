//
//  CustomScrViewTitleCollectionViewCell.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/17.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class CustomScrViewTitleCollectionViewCell: SuperCollectionViewCell {
    //MARK: ----------懒加载-----------
    private lazy var customBgView: UIView = {
        let customBgView = UIView()
        return customBgView
    }()
    private lazy var customLab: UILabel = {
        let customLab = UILabel()
        customLab.textAlignment = .center
        return customLab
    }()
    private lazy var lineView: UIView = {
        let lineView = UIView()
        return lineView
    }()
    
    override func setUpUI() {
        super.setUpUI()
        
        addSubView(customBgView)
        customBgView.addChildView([customLab, lineView])
    }
}

extension CustomScrViewTitleCollectionViewCell {
    func upDateCell(btnProprety: (UIColor, UIColor, UIFont, UIFont, UIEdgeInsets), bgViewProprety: (UIColor, UIColor, Double, UIEdgeInsets), lineViewProprety: (UIColor, UIEdgeInsets, CGFloat)?, btnTitle: String, select: Bool) {
        customBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(bgViewProprety.3)
        }
        customBgView.backgroundColor = !select ? bgViewProprety.0 : bgViewProprety.1
        customBgView.cornerRadius(CGFloat(bgViewProprety.2))
        
        customLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(btnProprety.4)
        }
        customLab.text = btnTitle
        customLab.textColor = !select ? btnProprety.0 : btnProprety.1
        customLab.font = !select ? btnProprety.2 : btnProprety.3
        
        if lineViewProprety != nil && select {
            lineView.isHidden = false
            
            if lineViewProprety!.2 <= 0 {
                lineView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview().inset(lineViewProprety!.1)
                }
            } else {
                lineView.snp.makeConstraints { (make) in
                    make.width.equalTo(lineViewProprety!.2)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(customBgView.snp.top).offset(lineViewProprety!.1.top)
                    make.bottom.equalTo(customBgView.snp.bottom).offset(-lineViewProprety!.1.bottom)
                }
            }
            lineView.backgroundColor = lineViewProprety!.0
        } else {
            lineView.isHidden = true
        }
    }
}
