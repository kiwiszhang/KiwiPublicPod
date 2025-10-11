//
//  SuperView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/24.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import Localize_Swift

open class SuperView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setUpUI()
        getData()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        getData()
    }
}

//MARK: ----------UI-----------
extension SuperView {
    @objc open func setUpUI() {
        backgroundColor(.clear)
    }
    
    @objc open func getData() {
        
    }
}

//MARK: ----------切换语言-----------
extension SuperView {
    @objc open func updateLanguageUI() {
        // 子类重写此方法实现具体更新逻辑
    }
}
