//
//  PurchaseTableViewCell.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/31.
//

import UIKit
import StoreKit

class PurchaseTableViewCell: SuperTableViewCell {
    private lazy var selectState: Bool? = false
    private lazy var bgView = UIView().cornerRadius(10)
    private lazy var coverView = UIView()
    private lazy var lineView = UIView().backgroundColor(.red)
    private lazy var selectView: UIImageView = UIImageView()
    private lazy var iconImage:UIImageView = UIImageView()
    private lazy var lockIcon = UIImageView(image: UIImage(systemName: "lock.fill"))
    private lazy var priceLab: UILabel = {
        return UILabel().color(.black).hnFont(size: 18.h, weight: .mediumBase)
    }()
    private lazy var typeLab: UILabel = {
        return UILabel().color(.black).hnFont(size: 15.h, weight: .mediumBase).leftAligned()
    }()
    private lazy var subLab1: UILabel = {
        return UILabel().color(.black).hnFont(size: 16.h,weight: .regularBase)
    }()
//    private let subLab2: UILabel = {
//        return UILabel().color(.black).text(L10n.buyPerWeek).hnFont(size: 12.h)
//    }()
    private lazy var lockLab:UILabel = {
        return UILabel().color(.yellow).text("未解锁").hnFont(size: 34.h, weight: .boldBase).centerAligned().backgroundColor(.systemCyan)
    }()
//
    override func setUpUI() {
        backgroundColor(.white)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(54.h)
            make.bottom.equalToSuperview().offset(-20.h)
        }
        
        bgView.addChildView([selectView, priceLab, typeLab, subLab1])
        selectView.snp.makeConstraints { make in
            make.width.height.equalTo(40.w)
            make.left.equalToSuperview().offset(13.w)
            make.centerY.equalToSuperview()
        }
        priceLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(selectView.snp.right).offset(20.w)
        }
        typeLab.snp.makeConstraints { make in
            make.bottom.equalTo(priceLab)
            make.left.equalTo(priceLab.snp.right)
        }
        subLab1.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20.w)
            make.top.equalToSuperview().offset(11.h)
        }
//        subLab2.snp.makeConstraints { make in
//            make.right.equalTo(subLab1)
//            make.bottom.equalToSuperview().offset(-9.h)
//        }
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.h)
        }
        
        self.contentView.addSubview(lockLab)
        lockLab.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        lockLab.addSubView(lockIcon)
        lockIcon.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(60.h)
        }
        
    }
    
//    func configure(with item: SubscriptionManager.ProductInfo) {
    func configure(with item: ProductItem) {
        bgView.layoutIfNeeded()
        priceLab.text(item.product.displayPrice)
        typeLab.text(item.info.desc)
        subLab1.text(item.info.icon)
        
        if item.isPurchased || item.product.type == .consumable || item.product.type == .autoRenewable{
            lockLab.hidden(true)
            lockIcon.hidden(true)
        }else{
            lockLab.hidden(false)
            lockIcon.hidden(false)
        }
    }
}
