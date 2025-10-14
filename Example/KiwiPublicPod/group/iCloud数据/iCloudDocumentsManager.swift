//
//  iCloudRecordAssetViewController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//

import Foundation
import UIKit

class iCloudDocumentsManager:NSObject, UIDocumentPickerDelegate {
    static let shared = iCloudDocumentsManager()
    private override init() {}
    let fileManager = FileManager.default
    /// 获取 iCloud 容器 URL
    var iCloudDocumentsURL: URL? {
        guard let url = fileManager.url(forUbiquityContainerIdentifier: iCloudContainerID)?.appendingPathComponent("Documents") else {
            print("⚠️ iCloud不可用，请检查容器配置和登录状态")
            return nil
        }
        return url
    }
    
    // MARK: - 保存文件（新增或覆盖）
    func save(data: Data, fileName: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let documentsURL = iCloudDocumentsURL else {
            completion(false, NSError(domain: "iCloud", code: 0, userInfo: [NSLocalizedDescriptionKey: "iCloud不可用"]))
            return
        }
        let fileURL = documentsURL.appendingPathComponent(fileName)

        DispatchQueue.global().async {
            do {
                // 确保 Documents 文件夹存在
                try self.fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil)
                try data.write(to: fileURL, options: .atomic)
                print("✅ 文件保存成功: \(fileName)")
                DispatchQueue.main.async { completion(true, nil) }
            } catch {
                print("❌ 文件保存失败: \(error)")
                DispatchQueue.main.async { completion(false, error) }
            }
        }
    }

    // MARK: - 删除文件
    func delete(fileName: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let documentsURL = iCloudDocumentsURL else {
            completion(false, nil)
            return
        }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        DispatchQueue.global().async {
            do {
                if self.fileManager.fileExists(atPath: fileURL.path) {
                    try self.fileManager.removeItem(at: fileURL)
                    print("✅ 删除成功: \(fileName)")
                }
                DispatchQueue.main.async { completion(true, nil) }
            } catch {
                print("❌ 删除失败: \(error)")
                DispatchQueue.main.async { completion(false, error) }
            }
        }
    }
    // MARK: - 读取 iCloud 文件
    func loadFromiCloud(fileName: String) -> Data? {
        guard let iCloudURL = iCloudDocumentsURL else { return nil }
        let fileURL = iCloudURL.appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }

    // MARK: - 列出 iCloud 文件
    func listiCloudFiles() -> [String] {
        guard let iCloudURL = iCloudDocumentsURL else { return [] }
        return (try? fileManager.contentsOfDirectory(atPath: iCloudURL.path)) ?? []
    }

    // MARK: - 导入文件（用户选择本地文件）
    func importFile(from viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        self.importCompletion = completion
        viewController.present(picker, animated: true)
    }

    private var importCompletion: ((Bool, Error?) -> Void)?

    @objc func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let localURL = urls.first,
              let documentsURL = iCloudDocumentsURL else {
            importCompletion?(false, NSError(domain: "iCloud", code: 0, userInfo: [NSLocalizedDescriptionKey: "iCloud不可用或未选择文件"]))
            return
        }

        let destinationURL = documentsURL.appendingPathComponent(localURL.lastPathComponent)

        DispatchQueue.global().async {
            do {
                try self.fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil)
                if self.fileManager.fileExists(atPath: destinationURL.path) {
                    try self.fileManager.removeItem(at: destinationURL)
                }
                try self.fileManager.copyItem(at: localURL, to: destinationURL)
                DispatchQueue.main.async { self.importCompletion?(true, nil) }
            } catch {
                DispatchQueue.main.async { self.importCompletion?(false, error) }
            }
        }
    }

    @objc func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        importCompletion?(false, NSError(domain: "iCloud", code: 0, userInfo: [NSLocalizedDescriptionKey: "用户取消选择文件"]))
    }

    // MARK: - 导出文件（用户选择保存路径）
    func exportFile(fileName: String, from viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        guard let data = loadFromiCloud(fileName: fileName) else {
            completion(false, NSError(domain: "iCloud", code: 0, userInfo: [NSLocalizedDescriptionKey: "文件不存在"]))
            return
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: tempURL)

            let picker = UIDocumentPickerViewController(forExporting: [tempURL], asCopy: true)
            picker.delegate = self
            self.exportCompletion = completion
            viewController.present(picker, animated: true)
        } catch {
            completion(false, error)
        }
    }

    private var exportCompletion: ((Bool, Error?) -> Void)?

}
