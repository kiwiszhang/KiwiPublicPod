//
//  PlayerTools.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/16.
//

import UIKit
import SnapKit

public struct PopupMenuItem {
    public let title: String
    public let icon: UIImage?
    public let isDestructive: Bool

    public init(title: String,
         icon: UIImage? = nil,
         isDestructive: Bool = false) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
    }
}


open class PopupMenu: UIView {
    
    private let items: [PopupMenuItem]
    private let contentView = UIView()
    public lazy var mView = UIView()

    private lazy var tableView = {
        return UITableView(frame: .zero, style: .grouped).delegate(self).dataSource(self).separatorStyle(.none).backgroundColor(.clear).registerCells(PopupMenuItemCell.self).scrollEnable(false).headerHeight(0.01).footerHeight(0.01).clipsToBounds(true).registerHeaderFooters(SuperTableViewHeaderFooterView.self).showsH(false).showsV(false)
    }()
    
    private var action: ((Int) -> Void)?

    public var rowHeight: CGFloat = 48.h
    public var menuWidth: CGFloat = 200.w
    public var cornerRadius: CGFloat = 12.h

    // MARK: - Init
    public init(items: [PopupMenuItem]) {
        self.items = items
        super.init(frame: .zero)
        setupUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    public func show(at point: CGPoint,
              in container: UIView? = kkKeyWindow(),
              action: @escaping (Int) -> Void) {

        guard let container = container else { return }
        self.action = action

        frame = container.bounds
        container.addSubview(self)

        let height = CGFloat(items.count) * rowHeight
        contentView.frame = CGRect(
            x: point.x - menuWidth,
            y: point.y,
            width: menuWidth,
            height: height
        )

        contentView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.rowHeight(rowHeight)

        UIView.animate(withDuration: 0.2) {
            self.contentView.alpha = 1
            self.contentView.transform = .identity
        }
    }

    // MARK: - UI
    private func setupUI() {
        backgroundColor = .clear

        // 背景遮罩
        mView.backgroundColor = .clear
        addSubview(mView)
        mView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        mView.addGestureRecognizer(tap)

        // 内容容器
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.cornerRadius(cornerRadius)
        addSubview(contentView)

        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.rowHeight(rowHeight)
    }


    // MARK: - Actions
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

//MARK: ----------TableViewDelegateDataSource-----------
extension PopupMenu: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PopupMenuItemCell.self, for: indexPath)
        cell.selectionStyle = .none
        let islast = indexPath.row == items.count - 1
        cell.configure(with: items[indexPath.row],islast: islast)
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
        action?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueHeaderFooter(SuperTableViewHeaderFooterView.self)
        return head
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = tableView.dequeueHeaderFooter(SuperTableViewHeaderFooterView.self)
        return foot
    }
}

class PopupMenuItemCell: SuperTableViewCell {
    private lazy var iconImageV = UIImageView().enable(true)
    private lazy var titleL = UILabel().text("title").color(.black).hnFont(size: 14.h, weight: .mediumBase)
    private lazy var line = UIView().backgroundColor(kkColorFromHex("ECECED"))
    override func setUpUI() {
        contentView.addChildView([iconImageV,titleL,line])
        contentView.backgroundColor(.clear)
        
        iconImageV.snp.makeConstraints { make in
            make.width.height.equalTo(20.h)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.w)
        }
        
        titleL.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.w)
            make.right.equalTo(iconImageV.snp.left).offset(-8.w)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-1)
        }
    }
    
    func configure(with item: PopupMenuItem,islast:Bool) {
        iconImageV.image(item.icon)
        titleL.text(item.title)
        line.hidden(islast)
    }
    
}
