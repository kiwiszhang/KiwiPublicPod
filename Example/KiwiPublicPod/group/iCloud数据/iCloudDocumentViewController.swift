//
//  iCloudRecordAssetViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//

import PhotosUI
import UIKit
import CloudKit

class iCloudDocumentViewController: SuperViewController {
    
    private let imageView = UIImageView()
    private var randomInt:Int = 0
    var dataList:[CKRecord] = []
    // MARK: - =====================lazy load=======================
    private lazy var selectPhoto = UILabel().text("选择照片").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
    }
    private lazy var saveToSandbox = UILabel().text("保存到沙盒").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        
        randomInt = Int.random(in: 1...1000000000000)
        UserDefaults.standard.set("image\(randomInt)", forKey: "imageName")
        let imageName = UserDefaults.standard.string(forKey: "imageName")
        _ = CloudKitPhotoManager.saveImageToSandbox(image: imageView.image!, imageName: imageName!)
    }
    
    private lazy var saveToiCloud = UILabel().text("保存到iCloud").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let imageName = UserDefaults.standard.string(forKey: "imageName")
        let image = CloudKitPhotoManager.loadImageFromDocumentDirectory(fileName: imageName!)
        if let imageData = image!.jpegData(compressionQuality: 0.9) {
            iCloudDocumentsManager.shared.save(data: imageData, fileName: "\(imageName!).jpg") { success, error in
                print(success ? "保存成功" : "保存失败: \(String(describing: error))")
            }
        }
    }
    
    private lazy var iCloudData = UILabel().text("从iCloud获取数据").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let imageName = UserDefaults.standard.string(forKey: "imageName")
        if let data = iCloudDocumentsManager.shared.loadFromiCloud(fileName: "\(imageName!).jpg"),
           let image = UIImage(data: data) {
            print("从iCloud获取数据")
            imageView.image = image
        }
    }
    
    private lazy var deleteFromiCloud = UILabel().text("删除iCloud数据").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let imageName = UserDefaults.standard.string(forKey: "imageName")
        iCloudDocumentsManager.shared.delete(fileName: "\(imageName!).jpg") { success, error in
            print(success ? "删除成功" : "删除失败: \(String(describing: error))")
        }
    }
    
    private lazy var updateiCloudData = UILabel().text("列出所有文件").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}

        let files = iCloudDocumentsManager.shared.listiCloudFiles()
        print("iCloud 文件列表: \(files)")
    }
    
    private lazy var importiCloud = UILabel().text("导入本地文件").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        iCloudDocumentsManager.shared.importFile(from: self) { success, error in
            print(success ? "导入成功" : "导入失败: \(String(describing: error))")
        }
    }
    
    private lazy var exportiCloudData = UILabel().text("导出文件到本地").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}

        iCloudDocumentsManager.shared.exportFile(fileName: "xxx.pdf", from: self) { success, error in
            print(success ? "导出成功" : "导出失败: \(String(describing: error))")
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout).delegate(self).dataSource(self).showsHV(false).registerCells(cloudCollecionViewCell.self).backgroundColor(.systemBrown)
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
        setUpUI()
        getData()
        
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(updateData),
                   name: Notification.Name(NotificationCenterKeys.CenterKeys.kICloudDataChanged.rawValue),
                   object: nil
               )
//        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterKeys.CenterKeys.kICloudDataChanged.rawValue), object: nil)
        kkNotification_add(observer: self, selector: #selector(updateData), name: NotificationCenterKeys.CenterKeys.kICloudDataChanged.rawValue)
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        title = "icloud+Asset数据同步"
        
        view.addChildView([selectPhoto,saveToSandbox,saveToiCloud,iCloudData,deleteFromiCloud,updateiCloudData,importiCloud,exportiCloudData,imageView,collectionView])
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
        
        importiCloud.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.left.equalToSuperview().offset(10.w)
            make.top.equalTo(deleteFromiCloud.snp.bottom).offset(10.h)
        }
        
        exportiCloudData.snp.makeConstraints { make in
            make.width.equalTo(150.w)
            make.height.equalTo(50.h)
            make.right.equalToSuperview().offset(-10.w)
            make.top.equalTo(deleteFromiCloud.snp.bottom).offset(10.h)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100.w)
            make.left.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(exportiCloudData.snp.bottom)
            make.height.equalTo(120.h)
        }
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================
    @objc func updateData() {
        CloudKitPhotoManager.queryFromRecord { [self] records, error in
            self.dataList = records
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

// MARK: - PHPickerViewControllerDelegate (iOS 14+)
@available(iOS 14, *)
extension iCloudDocumentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        // 加载图片
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if error != nil {
                DispatchQueue.main.async {
                    showAlertViewWithOutCancelButton(title: "标题", message: "加载失败") { _ in
                    }
                }
                return
            }
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
}
// MARK: - UICollectionViewDataSource
extension iCloudDocumentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cloudCollecionViewCell.self, for: indexPath)
        cell.configureAsset(with: dataList[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension iCloudDocumentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.w, height: 100.h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
