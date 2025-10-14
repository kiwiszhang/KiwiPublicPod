//
//  StrategyFooterB.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/19.
//

import UIKit

class StrategyFooterB: SuperCollectionReusableView,MeHomeSupplementaryProtocol {
    static let kind = UICollectionView.elementKindSectionFooter
    static let viewId = "StrategyFooterB"
    
    private lazy var titleLab = UILabel().text("").color(.systemBlue).hnFont(size: 24.w,weight: .regularBase).centerAligned()
    
    override func setUpUI() {
        backgroundColor = .systemPink
        self.addChildView([titleLab])
        titleLab.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20.h)
        }
    }
    
    func configure(with model: MeHomeSectionModel, section: Int, controller: UIViewController) {
        titleLab.text = "Footer for section \(model.footerData!)"
    }
    
    
    static func sizeForSupplementary(for section: MeHomeSectionModel) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
}
