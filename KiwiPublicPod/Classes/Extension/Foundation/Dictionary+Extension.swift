//
//  Dictionary+Extension.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// 词典解密
    var base64Dic: [String: Any] {
        var resultDic = [String: Any]()
        for (key, value) in self {
            if value is NSNull { resultDic[key as! String] = "" }
            if value is Dictionary {
                dicData(key: key as! String, value: value, resultDic: &resultDic)
            } else if value is Array<Any> {
                arrayData(key: key as! String, value: value, resultDic: &resultDic)
            } else {
                resultDic[key as! String] = (value as! String).FromBase64
            }
        }
        return resultDic
    }
    
    /// 词典类型数据
    private func dicData(key: String, value: Any, resultDic:inout [String: Any]) {
        resultDic[key] = (value as! Dictionary).base64Dic
    }
    
    /// 数组类型数据
    private func arrayData(key: String, value: Any, resultDic:inout [String: Any]) {
        var resultArray = [[String: Any]]()
        for dic in value as! Array<Any> {
            resultArray.append((dic as! Dictionary).base64Dic)
        }
        resultDic[key] = resultArray
    }
    
    /// 将 Dictionary 转换为指定的 Codable 类型
    /**
     struct PhotoRequest: Codable {
         let imageName: String?
         let name: String
         let index: Int?
     }
     let dict: [String: Any] = ["index": 1, "name": "Housing", "imageName": "Housing"]
     if let request = dict.decode(to: PhotoRequest.self) {
         print(request)
         // PhotoRequest(imageName: Optional("Housing"), name: "Housing", index: Optional(1))
     }
     **/
    func decode<T: Decodable>(to type: T.Type) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Decode error:", error)
            return nil
        }
    }
}
