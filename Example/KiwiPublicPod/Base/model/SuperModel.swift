//
//  SuperModel.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import Foundation
import HandyJSON

private let valueTypesMap: Dictionary<String, String> = [
    "c" : "Int8",
    "s" : "Int16",
    "i" : "Int32",
    "q" : "Int",
    "S" : "UInt16",
    "I" : "UInt32",
    "Q" : "UInt",
    "B" : "Bool",
    "d" : "Double",
    "f" : "Float",
    "{" : "Decimal"
]

@objcMembers
class SuperModel: NSObject {
    required override init() {}
    
    //MARK: ----------数据库-----------
    //主键,只能选择Int,String类型属性
    var primaryKey: String? {
        get {
            return nil
        }
    }
    var primaryValue: String!
    //父类ID
    var superTableID: String?
    //Swift不支持的类型
    var disableArray: [[String: String]]? {
        get {
            return nil
        }
    }
    //忽略属性
    var ignoreArray: [String]? {
        get {
            return ["primaryKey", "primaryValue"]
        }
    }
    //数组
    var modelArray: [String: String]? {
        get {
            return nil
        }
    }
    //对象
    var objectArray: [String: String]? {
        get {
            return nil
        }
    }
    //不支持数据类型转为String存储
    func disableArrayData(classNameStr: String, type: String) -> String? {
        return nil
    }
    //不支持数据类型由String解析为原数据类型
    func disableArrayData(classNameStr: String, value: String) -> Any? {
        return nil
    }
}
//MARK: ----------HandyJSON-----------
extension SuperModel: HandyJSON {
    
}
//MARK: ----------KVC-----------
extension SuperModel {
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
//MARK: ----------其他-----------
extension SuperModel {
    class func get_class_copyPropertyList() -> [[String: String]] {
        var outCount: UInt32 = 0
        let propers = class_copyPropertyList(self, &outCount)
        
        var propertyList = [[String: String]]()
        if outCount == 0 {
            return propertyList
        }
        for i in 0...(Int(outCount) - 1) {
            let property = [getNameOf(property: propers![i])!: getTypeOf(property: propers![i])!]
            propertyList.append(property)
        }
        return propertyList
    }
    
    /// 获取属性名
    private class func getNameOf(property: objc_property_t) -> String? {
        guard
            let name: NSString = NSString(utf8String: property_getName(property))
            else { return nil }
        return name as String
    }
    /// 获取属性类型
    private class func getTypeOf(property: objc_property_t) -> String? {
        guard let attributesAsNSString: NSString = NSString(utf8String: property_getAttributes(property)!) else { return nil }
        let attributes = attributesAsNSString as String
        let slices = attributes.components(separatedBy: "\"")
        guard slices.count > 1 else { return valueType(withAttributes: attributes) }
        let objectClassName = slices[1]
        return objectClassName
    }
    private class func valueType(withAttributes attributes: String) -> String? {
        let tmp = attributes as NSString
        let letter = tmp.substring(with: NSMakeRange(1, 1))
        guard let type = valueTypesMap[letter] else { return nil }
        return type
    }
}
//MARK: ----------NSCoding-----------
extension SuperModel {
    func encodeMethord(with aCoder: NSCoder) {
        for item in classForCoder.get_class_copyPropertyList() {
            aCoder.encode(value(forKey: item.keys.first!), forKey: item.keys.first!)
        }
    }
    func initCodeMethord(with aCoder: NSCoder) {
        for item in classForCoder.get_class_copyPropertyList() {
            setValue(aCoder.decodeObject(forKey: item.keys.first!), forKey: item.keys.first!)
        }
    }
}

