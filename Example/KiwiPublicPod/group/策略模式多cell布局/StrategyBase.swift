//
//  呃呃呃呃ViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/19.
//

import UIKit

class SectionDetailModel {
    var dataList: [String]
    
    init(dataList: [String]) {
        self.dataList = dataList
    }
}

// MARK: - Section 数据模型
class MeHomeSectionModel {
    var type: String        // cell 类型
    var headerType: String? // header 类型
    var footerType: String? // footer 类型
    var cellData: SectionDetailModel?     // 存放该 section 的数据
    var headerData: String?
    var footerData: String?

    
    init(type: String, headerType: String? = nil, footerType: String? = nil,headerData: String? = nil, footerData: String? = nil, data: SectionDetailModel? = nil) {
        self.type = type
        self.headerType = headerType
        self.footerType = footerType
        self.cellData = data
        self.footerData = footerData
        self.headerData = headerData
    }
}

// MARK: - Cell 策略协议
protocol MeHomeCellProtocol where Self: SuperCollectionViewCell {
    static func numberOfItems(for section: MeHomeSectionModel) -> Int
    static func sizeForItem(for section: MeHomeSectionModel) -> CGSize
    static func edgeInsets(for section: MeHomeSectionModel) -> UIEdgeInsets
    static func interitemSpacing(for section: MeHomeSectionModel) -> CGFloat
    static func lineSpacing(for section: MeHomeSectionModel) -> CGFloat
    
    func configure(with model: MeHomeSectionModel, indexPath: IndexPath, controller: UIViewController)
    func didSelectItem(with model: MeHomeSectionModel, indexPath: IndexPath, controller: UIViewController)
}

// MARK: - 默认实现
extension MeHomeCellProtocol {
    /// 返回当前这一组有多少个cell
    static func numberOfItems(for section: MeHomeSectionModel) -> Int { return 1 }
    /// 返回当前这组的cell大小
    static func sizeForItem(for section: MeHomeSectionModel) -> CGSize { return CGSize(width: 100, height: 100) }
    /// 设置内边距
    static func edgeInsets(for section: MeHomeSectionModel) -> UIEdgeInsets { return .zero }
    /// 行与行之间的最小间距（垂直滚动时）或列与列之间的间距（水平滚动时）
    static func interitemSpacing(for section: MeHomeSectionModel) -> CGFloat { return 0 }
    /// 同一行（或同一列）内，相邻单元格之间的最小间距
    static func lineSpacing(for section: MeHomeSectionModel) -> CGFloat { return 0 }
    
    func didSelectItem(with model: MeHomeSectionModel, indexPath: IndexPath, controller: UIViewController) {}
}

// MARK: - Header/Footer 策略协议
protocol MeHomeSupplementaryProtocol where Self: SuperCollectionReusableView {
    static var kind: String { get }   // UICollectionView.elementKindSectionHeader / Footer
    static var viewId: String { get }
    static func sizeForSupplementary(for section: MeHomeSectionModel) -> CGSize
    func configure(with model: MeHomeSectionModel, section: Int, controller: UIViewController)
}

extension MeHomeSupplementaryProtocol {
    static func sizeForSupplementary(for section: MeHomeSectionModel) -> CGSize { return .zero }
}
