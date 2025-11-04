//
//  CustomNineGirdView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/24.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class CustomNineGirdView: SuperView {
    var nineGirdViewHeight: CGFloat = 0
    
    /// 九宫格
    ///
    /// - Parameters:
    ///   - viewArray: view数组
    ///   - nineGirdWidth: 九宫格宽度
    ///   - itemHeight: <1 高/宽 >1 高度值
    ///   - colums: 列
    ///   - HMargin: 水平间距
    ///   - VMargin: 垂直间距
    init(viewArray: [UIView], nineGirdWidth: CGFloat, itemHeight: (CGFloat, Bool), colums: NSInteger, HMargin: CGFloat, VMargin: CGFloat) {
        super.init(frame: CGRect.zero)
        
        let itemViewWidth = (nineGirdWidth - CGFloat(colums - 1) * HMargin) / CGFloat(colums)
        let itemViewHeight = itemHeight.1 ? itemHeight.0 : itemHeight.0 * itemViewWidth
        for (index, view) in viewArray.enumerated() {
            addSubview(view)
            
            view.snp.makeConstraints { (make) in
                make.width.equalTo(itemViewWidth)
                make.height.equalTo(itemViewHeight)
                make.left.equalToSuperview().offset(CGFloat(index % colums) * (itemViewWidth + HMargin))
                make.top.equalToSuperview().offset(CGFloat(index / colums) * (itemViewHeight + VMargin))
            }
            if index == viewArray.count - 1 {
                if viewArray.count <= colums {
                    nineGirdViewHeight = itemViewHeight
                } else {
                    if colums == 1 {
                        nineGirdViewHeight = CGFloat(viewArray.count) * (itemViewHeight + VMargin) - VMargin
                    } else {
                        let rows = ceil(Double(viewArray.count) / Double(colums))
                        nineGirdViewHeight = CGFloat(rows) * (itemViewHeight + VMargin) - VMargin
                    }
                }
            }
        }
    }
    
    /// 九宫格
    ///
    /// - Parameters:
    ///   - viewArray: view数组
    ///   - nineGirdWidth: 九宫格宽度
    ///   - itemWidth: 宽度值
    ///   - itemHeight: <1 高/宽 >1 高度值
    ///   - colums: 列
    ///   - VMargin: 垂直间距
    init(viewArray: [UIView], nineGirdWidth: CGFloat, itemWidth: CGFloat, itemHeight: (CGFloat, Bool), colums: NSInteger, VMargin: CGFloat, maxHMargin: CGFloat = CGFloat(MAXFLOAT)) {
        super.init(frame: CGRect.zero)
        
        let itemViewWidth = itemWidth
        let HMargin = min((nineGirdWidth - itemWidth * CGFloat(viewArray.count)) / CGFloat((viewArray.count - 1)), maxHMargin)
        let itemViewHeight = itemHeight.1 ? itemHeight.0 : itemHeight.0 * itemViewWidth
        for (index, view) in viewArray.enumerated() {
            addSubview(view)
            
            view.snp.makeConstraints { (make) in
                make.width.equalTo(itemViewWidth)
                make.height.equalTo(itemViewHeight)
                make.left.equalToSuperview().offset(CGFloat(index % colums) * (itemViewWidth + HMargin))
                make.top.equalToSuperview().offset(CGFloat(index / colums) * (itemViewHeight + VMargin))
            }
            if index == viewArray.count - 1 {
                if viewArray.count <= colums {
                    nineGirdViewHeight = itemViewHeight
                } else {
                    if colums == 1 {
                        nineGirdViewHeight = CGFloat(viewArray.count) * (itemViewHeight + VMargin) - VMargin
                    } else {
                        let rows = ceil(Double(viewArray.count) / Double(colums))
                        nineGirdViewHeight = CGFloat(rows) * (itemViewHeight + VMargin) - VMargin
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
