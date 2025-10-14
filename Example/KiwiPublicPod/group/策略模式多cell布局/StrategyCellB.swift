//
//  StrategyCellB.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/19.
//

import UIKit

class StrategyCellB: SuperCollectionViewCell,MeHomeCellProtocol {
    
    private lazy var containerView = UIView().backgroundColor(.systemGray)
    private lazy var titleLab = UILabel().text("").color(.white).hnFont(size: 24.w,weight: .regularBase).centerAligned()
    
    override func setUpUI() {
        contentView.addSubView(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        containerView.addChildView([titleLab])
        titleLab.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20.h)
        }
    }
    
    func configure(with model: MeHomeSectionModel, indexPath: IndexPath, controller: UIViewController) {
        titleLab.text = "CellB \(model.cellData?.dataList[indexPath.row] ?? "")"
    }
    
    /// 返回当前这一组有多少个cell
    static func numberOfItems(for section: MeHomeSectionModel) -> Int {
        return (section.cellData?.dataList.count)!
    }
    /// 返回当前这组的cell大小
    static func sizeForItem(for section: MeHomeSectionModel) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30.h) / 2, height: 100)
    }
    /// 设置内边距
    static func edgeInsets(for section: MeHomeSectionModel) -> UIEdgeInsets {
        return .zero
    }
    /// 行与行之间的最小间距（垂直滚动时）或列与列之间的间距（水平滚动时）
    static func interitemSpacing(for section: MeHomeSectionModel) -> CGFloat {
        return 30.h
    }
    /// 同一行（或同一列）内，相邻单元格之间的最小间距
    static func lineSpacing(for section: MeHomeSectionModel) -> CGFloat {
        return 60.h
    }
}
