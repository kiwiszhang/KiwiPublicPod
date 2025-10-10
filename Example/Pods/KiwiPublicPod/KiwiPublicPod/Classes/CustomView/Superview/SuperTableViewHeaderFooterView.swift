//
//  SuperTableViewHeaderFooterView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/24.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

open class SuperTableViewHeaderFooterView: UITableViewHeaderFooterView {
    //MARK: ----------初始化方法-----------
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
extension SuperTableViewHeaderFooterView {
    @objc open func setUpUI() {
        contentView.backgroundColor(.clear)
        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
    }
}
