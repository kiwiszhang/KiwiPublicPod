//
//  UICollectionView+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/4.
//

import UIKit

public extension UICollectionView {
    // MARK: - 基础配置
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    // MARK: - 交互配置
    @discardableResult
    func allowsSelection(_ allow: Bool) -> Self {
        allowsSelection = allow
        return self
    }
    
    @discardableResult
    func allowsMultipleSelection(_ allow: Bool) -> Self {
        allowsMultipleSelection = allow
        return self
    }
    
    // MARK: - 注册单元格
    /// 注册纯代码实现的单元格
    @discardableResult
    func registerCells<T: UICollectionViewCell>(_ types: T.Type...) -> Self {
        types.forEach {
            register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
        return self
    }
    
    /// 注册xib实现的单元格
    @discardableResult
    func registerNibCells<T: UICollectionViewCell>(_ types: T.Type...) -> Self {
        types.forEach { type in
            let identifier = String(describing: type)
            assertNibExists(for: type, identifier: identifier)
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: identifier)
        }
        return self
    }
    
    // MARK: - 注册补充视图
    /// 注册纯代码实现的补充视图（Header/Footer等）
    @discardableResult
    func registerSupplementaryViews<T: UICollectionReusableView>(
        _ types: T.Type...,
        kind: String
    ) -> Self {
        types.forEach {
            register($0, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: $0))
        }
        return self
    }
    
    /// 注册xib实现的补充视图
    @discardableResult
    func registerNibSupplementaryViews<T: UICollectionReusableView>(
        _ types: T.Type...,
        kind: String
    ) -> Self {
        types.forEach { type in
            let identifier = String(describing: type)
            assertNibExists(for: type, identifier: identifier)
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
        return self
    }
    
    // MARK: - 高级功能
    @discardableResult
    func backgroundView(_ view: UIView?) -> Self {
        backgroundView = view
        return self
    }
    
    // MARK: - 私有方法
    private func assertNibExists<T>(for type: T, identifier: String) {
        assert(
            Bundle.main.path(forResource: identifier, ofType: "nib") != nil,
            "未找到 \(identifier).xib 文件（用于注册 \(type)）"
        )
    }
    
    // MARK: - 安全解包
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("未注册的 Cell: \(identifier)")
        }
        return cell
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(
        _ type: T.Type,
        kind: String,
        for indexPath: IndexPath
    ) -> T {
        let identifier = String(describing: type)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("未注册的补充视图: \(kind)-\(identifier)")
        }
        return view
    }
}
