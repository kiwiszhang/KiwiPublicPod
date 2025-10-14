//
//  PurchaseViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/31.
//

import UIKit
import StoreKit

/*
 
 产品类型      可重复购买    可恢复购买    适用场景
 消耗型         ✅          ❌         游戏道具、虚拟货币
 非消耗型       ❌          ✅         解锁功能、永久权益
 自动续订订阅    ❌          ✅         持续服务、定期更新
 非续订订阅      ✅          ❌         课程、赛事、短期会员
 */

class PurchaseViewController: SuperViewController {
    var store = Store.shared
    var titleList:[String] = []
    var dataList:[[ProductItem]] = []
    // MARK: - =====================lazy load=======================
    private lazy var tableView = {
        return UITableView().delegate(self).dataSource(self).separatorStyle(.none).separatorColor(.clear).backgroundColor(.clear).registerCells(PurchaseTableViewCell.self).scrollEnable(true).estimatedRowHeight(54.h).rowHeight(60.h).showsV(false).registerHeaderFooters(PurchaseTableHeaderView.self)

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
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setUpUI()
        Task{
            await getListData()
        }
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func getData() {
        titleList = ["消耗品","非消耗品","非自动订阅产品","自动订阅产品"]
        
    }
    
    func getListData() async {
//        if store.fuel.count > 0 || store.cars.count > 0 || store.nonRenewables.count > 0 || store.subscriptions.count > 0 {
//            dataList = [store.fuel,store.cars,store.nonRenewables,store.subscriptions]
//            await store.updateCustomerProductStatus()
//        }else{
            await store.requestProducts()
            dataList = [store.consumables,store.nonConsumabls,store.nonRenewables,store.subscriptions]
//        }
        tableView.reloadData()
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------
extension PurchaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.h
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(PurchaseTableHeaderView.self)
        header.configure(with: titleList[section])
        return header
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = dataList[indexPath.section][indexPath.row]
        Task {
            let purchased = try? await store.isPurchased(product.product)
            guard purchased == false else {
                print("已购买，执行功能")
                return
            }
            // 发起购买
            if let _ = try? await store.purchase(product.product) {
                await store.updateCustomerProductStatus()
                await getListData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PurchaseTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        let product = dataList[indexPath.section][indexPath.row]
        cell.configure(with:product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
}
