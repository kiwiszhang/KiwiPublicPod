//
//  TestViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/10/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class TestViewController: ViewController {
    
    let dataList:Array<Any> = []
    // MARK: - =====================lazy load=======================
    private lazy var tableView = {
        return UITableView().delegate(self).dataSource(self).separatorStyle(.none).separatorColor(.clear).backgroundColor(.clear).registerCells(<#TableViewCell#>.self).scrollEnable(true).estimatedRowHeight(52).rowHeight(52).showsV(false)

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
        
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------
extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(<#TableViewCell#>, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return dataList.count
//    }
}
