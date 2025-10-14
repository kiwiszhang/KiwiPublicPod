//
//  iCloudUserViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//

/*
 A. 使用CoreData + CloudKit同步数据和持久化，有模型数据和照片,照片不使用CloudKit Asset存储的方式
    1. 开启 iCloud & CloudKit
         在 Xcode → Signing & Capabilities
         勾选 iCloud，选择 CloudKit
         选择/创建容器（例如 iCloud.com.yourcompany.yourapp）
         登录 Apple Developer，确保在 Certificates, Identifiers & Profiles 中已开启 iCloud
    2. 增加iCloudData.xcdatamodeld模型设计
        增加entity，每一个entity相当于是一个数据库的表
        选中entity在右侧勾选 Codegen → Class Definition
        在 Entity → Configurations 中，确保勾选 CloudKit 同步
        在entity中增加字段，id字段的类型需要是UUID
        如果是图片数据字段类型选择：Binary Data并且勾选 Allows External Storage
        勾选 Allows External Storage 后，大图会以文件形式外存，Core Data DB 不会暴涨
        CloudKit 镜像会自动把 Binary Data 映射为 CKAsset，你不用自己写上传逻辑
 
 
 
 
 
 */


import UIKit
import PhotosUI
import CloudKit

let kkPhotosPath = "photos"


class iCloudUseViewController: SuperViewController {
    
    let ctx = PersistenceController.shared.container.viewContext

    private let imageView = UIImageView()
    private var randomInt:Int = 0
    var dataList:[PhotoItem] = []
    // MARK: - =====================lazy load=======================
//    private lazy var tableView = {
//        return UITableView().delegate(self).dataSource(self).separatorStyle(.none).separatorColor(.clear).backgroundColor(.clear).registerCells(<#TableViewCell#>.self).scrollEnable(true).estimatedRowHeight(52).rowHeight(52).showsV(false)
//
//    }()
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
        _ = saveImageToSandbox(image: imageView.image!, imageName: "image" + "\(randomInt)")
    }
    
    private lazy var saveToiCloud = UILabel().text("同步到iCloud").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let image = loadImageFromDocumentDirectory(fileName: "image" + "\(randomInt)")
        addPhoto(image!)
    }
    
    private lazy var iCloudData = UILabel().text("从iCloud获取数据").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        loadAll()
    }
    
    private lazy var deleteFromiCloud = UILabel().text("删除iCloud数据").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        
        let store = PhotoStore(context: ctx)
        do {
            try store.delete(dataList.first!)
        } catch {
            print("delete error: \(error)")
        }
        
    }
    
    private lazy var updateiCloudData = UILabel().text("更新iCloud数据").hnFont(size: 14.h, weight: .boldBase).backgroundColor(.systemCyan).color(.red).centerAligned().onTap {
        [weak self] in
        guard let self = self else {return}
        let store = PhotoStore(context: ctx)
        do {
           let fatchlist = try store.fetchByField("title", value: "image105127232447")
            print(fatchlist)
        } catch {
            print("delete error: \(error)")
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
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        title = "CoreData+CloudKit数据同步"
        view.addChildView([selectPhoto,saveToSandbox,saveToiCloud,iCloudData,deleteFromiCloud,updateiCloudData,imageView,collectionView])
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
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100.w)
            make.left.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(updateiCloudData.snp.bottom)
            make.height.equalTo(120.h)
        }
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================
    func addPhoto(_ image: UIImage) {
        let store = PhotoStore(context: ctx)
        do {
            try store.add(.init(title: "image\(randomInt)", image: image, size: image.pngData()?.count))
        } catch {
            print("Add error: \(error)")
        }
    }

    func loadAll() {
        let store = PhotoStore(context: ctx)
        do {
            let all = try store.fetchAll()
            // 用 all 渲染 UI
            for photoItem in all {
                imageView.image(UIImage(data: (photoItem.imageData)!))
            }
            dataList = all
            collectionView.reloadData()
            
        } catch {
            print("Fetch error: \(error)")
        }
    }
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDir.appendingPathComponent("\(kkPhotosPath)/\(fileName)")
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func saveImageToSandbox(image: UIImage, imageName: String) -> Bool {
        // 1. 获取 Document 目录路径
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("无法获取 Document 目录")
            return false
        }
        
        // 2. 创建子目录
        let photoDirectory = documentDirectory.appendingPathComponent(kkPhotosPath)
        
        do {
            try FileManager.default.createDirectory(at: photoDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("创建目录失败: \(error.localizedDescription)")
            return false
        }
        
        // 3. 构造图片保存路径
        let imageURL = photoDirectory.appendingPathComponent(imageName)
        
        // 4. 将 UIImage 转换为 Data
        guard let imageData = image.pngData() else {
            print("无法将图片转换为 Data")
            return false
        }
        
        // 5. 写入文件
        do {
            try imageData.write(to: imageURL)
            print("图片保存成功: \(imageURL.path)")
            return true
        } catch {
            print("保存图片失败: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

// MARK: - PHPickerViewControllerDelegate (iOS 14+)
@available(iOS 14, *)
extension iCloudUseViewController: PHPickerViewControllerDelegate {
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
extension iCloudUseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cloudCollecionViewCell.self, for: indexPath)
        cell.configure(with: dataList[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension iCloudUseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.w, height: 100.h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

class cloudCollecionViewCell: SuperCollectionViewCell {
    private lazy var containerView = UIView().backgroundColor(kkColorFromHexWithAlpha("D6B6F5", 0.4))
    private lazy var imgView = UIImageView()
    private lazy var titleLab = UILabel().text("").color(kkColorFromHex("EEEEEE")).hnFont(size: 12.w,weight: .regularBase).centerAligned()
    
    override func setUpUI() {
        contentView.addSubView(containerView)
        containerView.backgroundColor = .systemGreen
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        containerView.addChildView([imgView,titleLab])
        titleLab.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20.h)
        }
        imgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLab.snp.top)
        }
        
    }
    
    func configure(with item: PhotoItem) {
        imgView.image(UIImage(data: (item.imageData)!))
        print(item.title! as String)
        titleLab.text(item.title)
        
    }
    
    func configureAsset(with record: CKRecord) {
        if let title = record["title"] as? String {
            titleLab.text(title)
        }

        if let age = record["age"] as? Int {
            print("数量：\(age)")
        }
        
        if let asset = record["photo"] as? CKAsset,
           let fileURL = asset.fileURL {
            
            // 从 fileURL 读取文件数据
            do {
                let imageData = try Data(contentsOf: fileURL)
                
                // 转成 UIImage
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async { [self] in
                        // 这里更新 UI，比如设置到 UIImageView
                        imgView.image = image
                        print("图片加载成功")
                    }
                } else {
                    print("无法将数据转成 UIImage")
                }
            } catch {
                print("读取图片数据失败: \(error.localizedDescription)")
            }
        } else {
            print("photo 字段为空或不是 CKAsset 类型")
        }
        
    }
}
