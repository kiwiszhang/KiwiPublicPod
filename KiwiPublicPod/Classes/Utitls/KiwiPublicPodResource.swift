//
//  ProjectBaseResource.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/26.
//
import UIKit

public final class KiwiPublicPodResource {
    /// 获取当前 Pod 的资源 Bundle
    static var bundle: Bundle {
        // 先找到当前类所在的 bundle
        let bundle = Bundle(for: KiwiPublicPodResource.self)
        // 如果资源被打包到 KiwiPublicPod.bundle，则进一步定位
        if let resourceURL = bundle.url(forResource: "KiwiPublicPod", withExtension: "bundle"),
           let resourceBundle = Bundle(url: resourceURL) {
            return resourceBundle
        }
        return bundle
    }

    /// 从资源包加载图片
    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    /// 从资源包加载本地化字符串
    public static func localizedString(forKey key: String, value: String? = nil) -> String {
        return bundle.localizedString(forKey: key, value: value, table: nil)
    }

    /// 读取 JSON 文件
    public static func json(named name: String) -> Data? {
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

