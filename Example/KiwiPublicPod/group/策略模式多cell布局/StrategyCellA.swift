//
//  StrategyCellA.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/19.
//

import UIKit

class StrategyCellA: SuperCollectionViewCell,MeHomeCellProtocol {    
    private lazy var containerView = UIView().backgroundColor(.white)
    private lazy var titleLab = UILabel().text("").color(.systemBlue).hnFont(size: 24.w,weight: .regularBase).centerAligned()
    
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
        titleLab.text = "CellA \(model.cellData?.dataList[indexPath.row] ?? "")"
    }
    
    /// 返回当前这一组有多少个cell
    static func numberOfItems(for section: MeHomeSectionModel) -> Int {
        return (section.cellData?.dataList.count)!
    }
    /// 返回当前这组的cell大小
    static func sizeForItem(for section: MeHomeSectionModel) -> CGSize {
        /// 如果要一行排满三个，还设置了interitemSpacing的话，需要将屏宽减去相应的 一排几个乘以interitemSpacing的值
        /// 比如排n个就是( n - 1) * interitemSpacing 如果设置了edgeInsets这个值也需要减去相应的
        return CGSize(width: (UIScreen.main.bounds.width - 20.h) / 3, height: 80)
    }
    /// 设置内边距
    static func edgeInsets(for section: MeHomeSectionModel) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return .zero
    }
    /// 行与行之间的最小间距（垂直滚动时）或列与列之间的间距（水平滚动时）
    static func interitemSpacing(for section: MeHomeSectionModel) -> CGFloat {
        return 10.h
    }
    /// 同一行（或同一列）内，相邻单元格之间的最小间距
    static func lineSpacing(for section: MeHomeSectionModel) -> CGFloat {
        return 30.h
    }
    /// 点击cell
    func didSelectItem(with model: MeHomeSectionModel, indexPath: IndexPath, controller: UIViewController) {
        print("\(model.cellData?.dataList[indexPath.row] ?? "\(indexPath.row)")")
    }

}
