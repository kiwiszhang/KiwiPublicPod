//
//  PhotoStore.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//

import UIKit
import CoreData

struct PhotoRequest {
    let title: String?
    let image: UIImage
    let size:Int?
}

enum PhotoStoreError: Error { case imageEncodeFailed }

final class PhotoStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // 新增一条照片
    func add(_ req: PhotoRequest) throws {
        guard let data = req.image.jpegData(compressionQuality: 0.9) else {
            throw PhotoStoreError.imageEncodeFailed
        }
        let item = PhotoItem(context: context)
        item.id = UUID()
        item.title = req.title
        item.size = Double(data.count)
        item.imageData = data   // Binary Data（允许外存）-> CloudKit 会把它映射为 CKAsset

        try context.save()      // 触发本地保存 & 后台镜像到 CloudKit
    }

    // 读取所有
    func fetchAll() throws -> [PhotoItem] {
        let req: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        return try context.fetch(req)
    }

    // 删除
    func delete(_ item: PhotoItem) throws {
        context.delete(item)
        try context.save()
    }
    
    /// 按字段查找 Person
   /// - Parameters:
   ///   - field: 实体属性名（如 "name"、"id" 等）
   ///   - value: 匹配值
   ///   - exactMatch: 是否精确匹配（默认 true）
   ///   - ascending: 是否升序（默认 true）
       func fetchByField<T>(
           _ field: String,
           value: T,
           exactMatch: Bool = true,
           ascending: Bool = true
       ) throws -> [PhotoItem] {
           let req: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()

           if exactMatch {
               req.predicate = NSPredicate(format: "%K == %@", field, value as! CVarArg)
           } else {
               // 模糊匹配（不区分大小写、忽略音调）
               req.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", field, value as! CVarArg)
           }

           req.sortDescriptors = [NSSortDescriptor(key: field, ascending: ascending)]

           return try context.fetch(req)
       }
    
//    // 模糊匹配 name
//    let fuzzyResults = try store.fetchByField("name", value: "明", exactMatch: false)
//    // 按 createDate 精确匹配
//    let dateResults = try store.fetchByField("createDate", value: "2025-08-15")

}
