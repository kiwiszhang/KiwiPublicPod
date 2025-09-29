//
//  ProjectBaseResource.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/26.
//
import UIKit

public final class ProjectBaseResource {
    /// 获取 ProjectBaseResources.bundle
    private static var resourceBundle: Bundle? = {
        let bundle = Bundle(for: ProjectBaseResource.self)
        if let url = bundle.url(forResource: "ProjectBaseResources", withExtension: "bundle") {
            return Bundle(url: url)
        }
        return nil
    }()

    /// 从资源包加载图片
    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }

    /// 从资源包加载本地化字符串
    public static func localizedString(forKey key: String, value: String? = nil) -> String {
        return resourceBundle?.localizedString(forKey: key, value: value, table: nil) ?? key
    }

    /// 读取 JSON 文件
    public static func json(named name: String) -> Data? {
        guard let url = resourceBundle?.url(forResource: name, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

