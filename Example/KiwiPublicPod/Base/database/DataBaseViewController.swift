//
//  DataBaseViewController.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/11/1.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class DataBaseViewController: SuperViewController {
    var id: NSInteger = 0
    //MARK: ----------懒加载-----------
    /// 创建
    private lazy var creatBtn: UIButton = {
        let creatBtn = UIButton().fontSize(14).titleColor(.white).background(.black).title("建表")
        creatBtn.addTarget(self, action: #selector(creatBtnMethord), for: .touchUpInside)
        return creatBtn
    }()
    /// 增
    private lazy var plusBtn: UIButton = {
        let plusBtn = UIButton().fontSize(14).titleColor(.white).background(.black).title("新增")
        plusBtn.addTarget(self, action: #selector(plusBtnMethord), for: .touchUpInside)
        return plusBtn
    }()
    /// 删
    private lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton().fontSize(14).titleColor(.white).background(.black).title("删除")
        deleteBtn.addTarget(self, action: #selector(deleteBtnMethord), for: .touchUpInside)
        return deleteBtn
    }()
    /// 改
    private lazy var updateBtn: UIButton = {
        let updateBtn = UIButton().fontSize(14).titleColor(.white).background(.black).title("改")
        updateBtn.addTarget(self, action: #selector(updateBtnBtnMethord), for: .touchUpInside)
        return updateBtn
    }()
    /// 查
    private lazy var inspectBtn: UIButton = {
        let inspectBtn = UIButton().fontSize(14).titleColor(.white).background(.black).title("查询所有")
        inspectBtn.addTarget(self, action: #selector(inspectBtnMethord), for: .touchUpInside)
        return inspectBtn
    }()
    /// 筛选查询
    private lazy var siftInspectBtn: UIButton = {
        let siftInspectBtn = UIButton().fontSize(14).titleColor(.white).background(.black).title("条件查询")
        siftInspectBtn.addTarget(self, action: #selector(siftInspectBtnMethord), for: .touchUpInside)
        return siftInspectBtn
    }()
    /// 底部view
//    private lazy var bottomView: CustomNineGirdView = {
//        let bottomView = CustomNineGirdView.init(viewArray: [creatBtn, plusBtn, deleteBtn, updateBtn, inspectBtn, siftInspectBtn], nineGirdWidth: kkScreenWidth - 20, itemHeight: (40, true), colums: 3, HMargin: 10, VMargin: 10)
//        return bottomView
//    }()
    //MARK: ----------系统方法-----------
    override func setUpUI() {
        super.setUpUI()
        
        view.backgroundColor = .white
//        view.addSubview(bottomView)
//        bottomView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-10.w)
//            make.top.equalTo(safeTop)
//            make.left.equalToSuperview().offset(10.w)
//            make.height.equalTo(bottomView.nineGirdViewHeight)
//        }
    }
}
//MARK: ----------网络请求-----------
extension DataBaseViewController {
    private func testData() -> PersonModel {
        id += 2
        
        let nameArray = ["张三", "李四", "王五", "赵六", "孙七", "周八", "吴九", "郑十"]
        let emailArray = ["张三@qq.com", "李四@qq.com", "王五@qq.com", "赵六@qq.com", "孙七@qq.com", "周八@qq.com", "吴九@qq.com", "郑十@qq.com"]
        let provinceArray = ["A", "R", "D", "S"]
        let heightArray = [175, 180, 160, 154]
        let weightArray = [130, 160, 200]
        let schoolArray = ["长沙一中", "长沙二中", "长沙二高", "长沙一高", "湖南大学", "湖南师范", "长沙理工"]
        let addressArray = ["芙蓉区", "雨花区", "天心区", "岳麓区", "开福区", "长沙县", "望城区"]
        
        var educationArray = [EducationDetailModel]()
        let educationModel = EducationModel()
        for _ in 0 ..< (arc4random() % 4) {
            let educationDetailModel = EducationDetailModel()
            educationDetailModel.school = schoolArray[Int(arc4random()) % schoolArray.count]
            educationDetailModel.address = addressArray[Int(arc4random()) % addressArray.count]
            educationArray.append(educationDetailModel)
        }
        educationModel.ID = "\(id)"
        educationModel.totalNum = educationArray.count
        educationModel.educationDetail = educationArray
        
        let personModel = PersonModel()
        personModel.name = nameArray[Int(arc4random()) % nameArray.count]
        personModel.email = emailArray[Int(arc4random()) % emailArray.count]
        personModel.province = Character(provinceArray[Int(arc4random()) % provinceArray.count])
        personModel.height = Float(heightArray[Int(arc4random()) % heightArray.count])
        personModel.weight = Double(weightArray[Int(arc4random()) % weightArray.count])
        personModel.exterior = ExteriorStruct(height: personModel.height / 100.0, weight: personModel.weight )
        personModel.sex = Int(arc4random()) % 2 == 0
        personModel.education = educationModel
        return personModel
    }
}
//MARK: ----------其他-----------
extension DataBaseViewController {
    @objc private func creatBtnMethord() {
        DataBaseTool.sharedInstance.creatTable(model: PersonModel())
    }
    @objc private func plusBtnMethord() {
        var plusDataList: [SuperModel] = []
        
        for _ in 0...100 {
            plusDataList.append(testData())
        }
//        DataBaseTool.sharedInstance.insertData(model: testData())
        DataBaseTool.sharedInstance.insertData(modelArray: plusDataList)
    }
    @objc private func deleteBtnMethord() {
        let searchPersonModel = PersonModel()
        searchPersonModel.email = "张三@qq.com"
        
        DataBaseTool.sharedInstance.deleteData(model: searchPersonModel, parameters: ["email"])
    }
    @objc private func updateBtnBtnMethord() {
        let searchPersonModel = PersonModel()
        searchPersonModel.email = "张三@qq.com"
        searchPersonModel.height = 180
        
        let newPersonModel = PersonModel()
        newPersonModel.email = "***@qq.com"
        newPersonModel.height = 100
        
        DataBaseTool.sharedInstance.updateData(model: searchPersonModel, newModel: newPersonModel, parameters: ["email", "height"], newParameters: ["email", "height"])
    }
    @objc private func inspectBtnMethord() {
        //查询所有人数据
        let personArray = DataBaseTool.sharedInstance.quertyAllData(model: PersonModel()) as! [PersonModel]
        for personModel in personArray {
            MyLog("人 ++++++++++++++++ 主键: \(personModel.primaryValue ?? "") 姓名: \(personModel.name ?? "") 邮箱: \(personModel.email ?? "") 省份: \(personModel.province ?? "A") 外表: \(personModel.exterior ?? ExteriorStruct(height: 0, weight: 0)) 身高: \(personModel.height) 体重: \(personModel.weight) 性别: \(personModel.sex)")
            
            if personModel.education == nil {
                MyLog("学校信息 ++++++++++++++++ 未找到")
                continue
            }
            if personModel.education?.educationDetail?.count == 0 {
                MyLog("学校信息 ++++++++++++++++ 未找到")
                continue
            }
            for educationDetailModel in personModel.education!.educationDetail! {
                MyLog("主键: \(educationDetailModel.primaryValue ?? "") 学校信息 ++++++++++++++++ 学校: \(educationDetailModel.school ?? "") 地址: \(educationDetailModel.address ?? "")")
            }
        }
    }
    @objc private func siftInspectBtnMethord() {
        let searchPersonModel = PersonModel()
        searchPersonModel.email = "张三@qq.com"
        let personArray = DataBaseTool.sharedInstance.quertyDetailData(model: searchPersonModel, parameters: ["email"]) as! [PersonModel]
        for personModel in personArray {
            MyLog("姓名: \(personModel.name ?? "") 邮箱: \(personModel.email ?? "") 省份: \(personModel.province ?? "A") 外表: \(personModel.exterior ?? ExteriorStruct(height: 0, weight: 0)) 身高: \(personModel.height) 体重: \(personModel.weight) 性别: \(personModel.sex)")
        }
    }
}

