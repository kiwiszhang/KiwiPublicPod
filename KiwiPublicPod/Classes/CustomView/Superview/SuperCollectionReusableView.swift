//
//  SuperCollectionReusableView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/8.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

open class SuperCollectionReusableView: UICollectionReusableView {
    //MARK: ----------初始化方法-----------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
}
//MARK: ----------UI-----------
extension SuperCollectionReusableView {
    @objc open func setUpUI() {
        backgroundColor(.clear)
    }
}

