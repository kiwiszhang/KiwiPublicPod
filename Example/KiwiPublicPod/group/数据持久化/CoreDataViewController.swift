//
//  CoreDataViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/18.
//

import UIKit

class CoreDataViewController: SuperViewController {
    let manager = CoreDataManager.shared
    var dataList:[Person] = []
    // MARK: - =====================lazy load=======================
    private lazy var tableView = {
        return UITableView().delegate(self).dataSource(self).separatorStyle(.none).separatorColor(.clear).backgroundColor(.clear).registerCells(CoreDataTableViewViewCell.self).scrollEnable(true).estimatedRowHeight(52).rowHeight(52).showsV(false)
    }()
    
    private lazy var selectPhoto = UILabel().text("创建Person").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}

        
        let tom = manager.createPerson(name: randomString(), age: randomNumberString())
        let persons = manager.fetchPersons()
        dataList = persons
        tableView.reloadData()
    }
    private lazy var saveToSandbox = UILabel().text("创建Pet关联人").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let persons = manager.fetchPersons()
        
        let cat = manager.createPet(name: randomString(), type: "Cat", owner: persons.last!)

        dataList = manager.fetchPersons()
        tableView.reloadData()
    }
    
    private lazy var saveToiCloud = UILabel().text("更新Person").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}

        let persons = manager.fetchPersons()
        manager.updatePerson(person: persons.last!, newName: randomString(),newAge: randomNumberString())
        dataList = manager.fetchPersons()
        tableView.reloadData()
    }
    
    private lazy var iCloudData = UILabel().text("更新Pet").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let persons = manager.fetchPersons()
        let pets = manager.fetchPets(for: persons.last!)
        manager.updatePet(pet: pets.last!,newName: randomString(),type: "Dog")
        dataList = manager.fetchPersons()
        tableView.reloadData()
    }
    
    
    private lazy var deleteFromiCloud = UILabel().text("删除Person").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        
        let persons = manager.fetchPersons()
        manager.deletePerson(person: persons.first!)
        
        dataList = manager.fetchPersons()
        tableView.reloadData()
    }
    
    private lazy var updateiCloudData = UILabel().text("删除Pet").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}

        let persons = manager.fetchPersons()
        let pets = manager.fetchPets(for: persons.last!)
        manager.deletePet(pet: pets.last!)
        
        dataList = manager.fetchPersons()
        tableView.reloadData()
    }
    
    private lazy var button7 = UILabel().text("按条件查询Person").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}

        dataList = manager.fetchPersons(contains: "8")
        tableView.reloadData()
    }
    
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
        view.addChildView([selectPhoto,saveToSandbox,saveToiCloud,iCloudData,deleteFromiCloud,updateiCloudData,button7,tableView])
        selectPhoto.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.left.equalToSuperview().offset(10.w)
            make.top.equalToSuperview().offset(10.h)
        }
        
        saveToSandbox.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.right.equalToSuperview().offset(-10.w)
            make.top.equalToSuperview().offset(10.h)
        }
        
        saveToiCloud.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.left.equalToSuperview().offset(10.w)
            make.top.equalTo(selectPhoto.snp.bottom).offset(10.h)
        }
        
        iCloudData.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.right.equalToSuperview().offset(-10.w)
            make.top.equalTo(selectPhoto.snp.bottom).offset(10.h)
        }
        deleteFromiCloud.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.left.equalToSuperview().offset(10.w)
            make.top.equalTo(saveToiCloud.snp.bottom).offset(10.h)
        }
        
        updateiCloudData.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.right.equalToSuperview().offset(-10.w)
            make.top.equalTo(saveToiCloud.snp.bottom).offset(10.h)
        }
        
        button7.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.right.equalToSuperview().offset(-10.w)
            make.top.equalTo(deleteFromiCloud.snp.bottom).offset(10.h)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(button7.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================
    func randomString(length: Int = 8) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
    func randomNumberString(length: Int = 2) -> String {
        let digits = "0123456789"
        return String((0..<length).compactMap { _ in digits.randomElement() })
    }

    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------
extension CoreDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(CoreDataTableViewViewCell.self, for: indexPath)
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

class CoreDataTableViewViewCell: SuperTableViewCell {
    private lazy var containerView = UIView().backgroundColor(kkColorFromHexWithAlpha("65Bd45", 0.4))
    private lazy var titleLab = UILabel().text("").color(kkColorFromHex("EEEEEE")).hnFont(size: 12.w,weight: .regularBase).centerAligned()
    private lazy var petLab = UILabel().text("").color(.systemRed).hnFont(size: 12.w,weight: .regularBase).centerAligned().backgroundColor(.white)

    override func setUpUI() {
        contentView.addSubView(containerView)
        containerView.backgroundColor = .systemGreen
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        containerView.addChildView([titleLab,petLab])
        titleLab.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(80.w)
        }
        
        petLab.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(titleLab.snp.right)
        }
        
    }
    
    func configure(with item: Person) {
        titleLab.text(item.name)
        var petName = ""
        
        if let pets = item.pets as? Set<Pet> {
            for pet in pets {
                petName += pet.name!
            }
        }
        petLab.text(petName)
    }
    
}
