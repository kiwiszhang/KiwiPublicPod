//
//  HomeViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/9/29.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import KiwiPublicPod

class HomeViewController: SuperViewController {
    
    private var itemList:[String] = ["基础控件使用"]
    // MARK: -  =======================lazy========================
    private lazy var headerView = UILabel().text("tableHeader").centerAligned().backgroundColor(.systemCyan)
    private lazy var footerView = UILabel().text("footerView").centerAligned().backgroundColor(.systemCyan)
    private lazy var tableView = {
        return UITableView(frame: .zero, style: .grouped)
            .delegate(self).dataSource(self)
            .separatorStyle(.none)
            .backgroundColor(.clear)
            .registerCells(HomeItemCell.self)
            .registerHeaderFooters(SuperTableViewHeaderFooterView.self)
            .scrollEnable(true)
            .headerHeight(0.01)
            .footerHeight(0.01)
            .clipsToBounds(true)
            .rowHeight(62.h)
            .showsH(false)
            .showsV(false)
            .showsHV(false)
    }()
    
    // MARK: - =====================life cycle=======================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "首页"
        setUpUI()
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        view.addChildView([tableView])
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        tableView.tableHeader(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width:kkScreenWidth, height: 100.h)
        tableView.tableFooter(footerView)
        footerView.frame = CGRect(x: 0, y: 0, width:kkScreenWidth, height: 100.h)
        itemList = ["基础控件使用"]
        tableView.reloadData()
    }
    
    override func getData() {

    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================
}

//MARK: ----------TableViewDelegateDataSource-----------
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(HomeItemCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.configure(with: itemList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(WidgetViewController(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueHeaderFooter(SuperTableViewHeaderFooterView.self)
        return head
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = tableView.dequeueHeaderFooter(SuperTableViewHeaderFooterView.self)
        return foot
    }
}

class HomeItemCell: SuperTableViewCell {
    private lazy var titleLab = UILabel().hnFont(size: 14.h, weight: .medium).color(.systemCyan)
    override func setUpUI() {
        titleLab.backgroundColor = .yellow
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with item: String) {
        titleLab.text = item
    }
}
