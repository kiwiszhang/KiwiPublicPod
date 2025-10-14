//
//  List01ViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//

import UIKit

class List01ViewController: SuperViewController {
    
    var dataList:[String] = []
    // MARK: - =====================lazy load=======================
    private lazy var tableView = {
        return UITableView().delegate(self).dataSource(self).separatorStyle(.none).separatorColor(.clear).backgroundColor(.clear).registerCells(List01TableViewCell.self).scrollEnable(true).estimatedRowHeight(52).rowHeight(52).showsV(false)
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
        setUpUI()
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func getData() {
        title = "设置"
        dataList = ["CoreData+CloudKit数据同步","icloud+Asset数据同步","iCloud Document数据同步","四种内购处理","CoreData简单使用","策略模式多cell布局"]
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------
extension List01ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = SuperViewController()
        if indexPath.row == 0 {
            vc = iCloudUseViewController()
        }else if indexPath.row == 1 {
            vc = iCloudRecordAssetViewController()
        }else if indexPath.row == 2 {
            vc = iCloudDocumentViewController()
        }else if indexPath.row == 3 {
            vc = PurchaseViewController()
        }else if indexPath.row == 4 {
            vc = CoreDataViewController()
        }else if indexPath.row == 5 {
            vc = StrategyViewController()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(List01TableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.configure(with: dataList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return dataList.count
//    }
}

class List01TableViewCell: SuperTableViewCell {
    private lazy var containerView = UIView().backgroundColor(.systemCyan.withAlphaComponent(0.4))
    private lazy var titleLab = UILabel().text("").color(.systemGray3).hnFont(size: 15.w,weight: .regularBase).centerAligned()
    private lazy var line = UILabel().text("").backgroundColor(.systemRed)

    override func setUpUI() {
        contentView.addSubView(containerView)
        containerView.backgroundColor = .systemGreen
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        containerView.addChildView([titleLab,line])
        containerView.addSubview(line)
        titleLab.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.h)
        }
    }
    func configure(with item: String) {
        titleLab.text(item)
    }
}
