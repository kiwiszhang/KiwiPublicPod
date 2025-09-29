//
//  UITableView+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/4.
//

import UIKit

public extension UITableView {
    // MARK: - 基础配置
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }
    
    @discardableResult
    func headerHeight(_ height: CGFloat) -> Self {
        sectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    func footerHeight(_ height: CGFloat) -> Self {
        sectionFooterHeight = height
        return self
    }
    
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        separatorStyle = style
        return self
    }
    
    @discardableResult
    func separatorColor(_ color: UIColor) -> Self {
        separatorColor = color
        return self
    }
    
    // MARK: - 注册单元格
    /// 注册纯代码实现的单元格
    @discardableResult
    func registerCells<T: UITableViewCell>(_ types: T.Type...) -> Self {
        types.forEach {
            register($0, forCellReuseIdentifier: String(describing: $0))
        }
        return self
    }
    
    /// 注册xib实现的单元格
    @discardableResult
    func registerNibCells<T: UITableViewCell>(_ types: T.Type...) -> Self {
        types.forEach { type in
            let identifier = String(describing: type)
            assertNibExists(for: type, identifier: identifier)
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        }
        return self
    }
    
    // MARK: - 页眉页脚注册
    /// 自动选择注册方式
    @discardableResult
    func registerHeaderFooters<T: UITableViewHeaderFooterView>(_ types: T.Type...) -> Self {
        types.forEach { type in
            let identifier = String(describing: type)
            register(type, forHeaderFooterViewReuseIdentifier: identifier)
        }
        return self
    }
    
    /// 通过xib注册页眉页脚
    @discardableResult
    func registerNibHeaderFooters<T: UITableViewHeaderFooterView>(_ types: T.Type...) -> Self {
        types.forEach { type in
            let identifier = String(describing: type)
            assertNibExists(for: type, identifier: identifier)
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
        return self
    }
    
    // MARK: - 私有方法
    private func assertNibExists<T>(for type: T, identifier: String) {
        assert(
            Bundle.main.path(forResource: identifier, ofType: "nib") != nil,
            "未找到 \(identifier).xib 文件（用于注册 \(type)）"
        )
    }

    
    // MARK: - 交互配置
    //是否允许选中单元格
    @discardableResult
    func allowsSelection(_ allow: Bool) -> Self {
        allowsSelection = allow
        return self
    }
    
    //是否允许多选
    @discardableResult
    func allowsMultipleSelection(_ allow: Bool) -> Self {
        allowsMultipleSelection = allow
        return self
    }
    
    // MARK: - 高级功能
    //设置顶部固定视图（不会随滚动）高度需自行约束
    @discardableResult
    func tableHeader(_ view: UIView?) -> Self {
        tableHeaderView = view
        return self
    }
    
    //设置底部固定视图 高度需自行约束
    @discardableResult
    func tableFooter(_ view: UIView?) -> Self {
        tableFooterView = view
        return self
    }
    
    @discardableResult
    func backgroundView(_ view: UIView?) -> Self {
        backgroundView = view
        return self
    }
    
    //设置右侧索引条文字颜色
    @discardableResult
    func sectionIndexColor(_ color: UIColor?) -> Self {
        sectionIndexColor = color
        return self
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("未注册的 Cell: \(identifier)")
        }
        return cell
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        let identifier = String(describing: type)
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {fatalError("Header/Footer: \(identifier)")
        }
        return view
    }
}
