//
//  DataBaseTool.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/11/5.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import SQLite

class DataBaseTool: NSObject {
    private let DataBasePath = NSHomeDirectory() + "/Documents" + "/DataBase.sqlite"
    static let sharedInstance: DataBaseTool = {
        let sharedInstance = DataBaseTool()
        return sharedInstance
    }()
    private lazy var DataBaseDB: Connection = {
        let DataBaseDB = try! Connection.init(DataBasePath)
        MyLog("数据库路径" + DataBasePath)
        return DataBaseDB
    }()
}

//MARK: ----------操作-----------
extension DataBaseTool {
    //MARK: ----------表创建-----------
    /// 创建表
    ///
    /// - Parameter model: 模型
    func creatTable(model: SuperModel, extStr: String = "") {
        let table = Table(NSStringFromClass(type(of: model)) + extStr)
        let create = table.create(ifNotExists: true, block: { (builder) in
            //设置主键
            if model.primaryKey == nil {
                builder.column(SQLite.Expression<Int64>("dataBaseID"), primaryKey: true)
            }
            //上表ID
            builder.column(SQLite.Expression<String?>("superTableID"))
            //模型
            if model.objectArray != nil {
                for (key, _) in model.objectArray! {
                    builder.column(SQLite.Expression<String?>(key))
                }
            }
            //数组
            if model.modelArray != nil {
                for (key, _) in model.modelArray! {
                    builder.column(SQLite.Expression<String?>(key))
                }
            }
            //不可用
            var disableArray: [String] = []
            if model.disableArray != nil {
                for detailModelDic in model.disableArray! {
                    disableArray.append(detailModelDic.keys.first!)
                    builder.column(SQLite.Expression<String?>(detailModelDic.keys.first!))
                }
            }
            //字符,整形,浮点型,布尔
            for item in model.classForCoder.get_class_copyPropertyList() {
                if model.ignoreArray?.contains(item.keys.first!) ?? false { continue }
                if model.objectArray?.keys.contains(item.keys.first!) ?? false { continue }
                if model.modelArray?.keys.contains(item.keys.first!) ?? false { continue }
                if model.ignoreArray?.contains(item.keys.first!) ?? false {continue}
                if disableArray.contains(item.keys.first!) {continue}
                
                //设置主键
                if item.keys.first! == model.primaryKey {
                    builder.column(SQLite.Expression<String>(item.keys.first!), primaryKey: true)
                    continue
                }
                
                //次级表
                if model.objectArray != nil && item.keys.first! == "objectArray" {
                    for detailModelStr in model.objectArray!.values {
                        let className = kkProjectName + "." + detailModelStr
                        let detaiModel = NSClassFromString(className) as! SuperModel.Type
                        creatTable(model: detaiModel.init(), extStr: extStr);
                    }
                }
                //次级表
                if model.modelArray != nil && item.keys.first! == "modelArray" {
                    for detailModelStr in model.modelArray!.values {
                        let className = kkProjectName + "." + detailModelStr
                        let detaiModel = NSClassFromString(className) as! SuperModel.Type
                        creatTable(model: detaiModel.init(), extStr: extStr);
                    }
                }
                
                if item.values.first! == "NSString" {
                    builder.column(SQLite.Expression<String?>(item.keys.first!))
                }
                else if item.values.first! == "Int" {
                    builder.column(SQLite.Expression<Int64?>(item.keys.first!))
                }
                else if item.values.first! == "Double" || item.values.first! == "Float" {
                    builder.column(SQLite.Expression<Double?>(item.keys.first!))
                }
                else if item.values.first! == "Bool" {
                    builder.column(SQLite.Expression<Bool?>(item.keys.first!))
                } else {
                    builder.column(SQLite.Expression<String?>(item.keys.first!))
                }
            }
        })
        do {
            MyLog("创建表-----\(create)")
            try DataBaseDB.run(create)
        } catch  {
            MyLog(error.localizedDescription)
        }
    }
    
    //MARK: ----------数据新增,修改-----------
    /// 新增数据
    ///
    /// - Parameter model: 数据模型
    func insertData(model: SuperModel, extStr: String = "") {
        let table = Table(NSStringFromClass(type(of: model)) + extStr)
        
        //插入
        var insertSetterArray = [Setter]()
        //上表主键ID
        let str = model.value(forKey: "superTableID") as? String
        insertSetterArray.append(SQLite.Expression<String?>("superTableID") <- str)
        
        for item in model.classForCoder.get_class_copyPropertyList() {
            let type = item.keys.first!
            
            if model.ignoreArray?.contains(type) ?? false { continue }
            if item.values.first! == "NSString" {
                let str = model.value(forKey: item.keys.first!) as? String
                insertSetterArray.append(SQLite.Expression<String?>(type) <- str)
            }
            if item.values.first! == "Int" {
                let str = model.value(forKey: item.keys.first!) as? Int64
                insertSetterArray.append(SQLite.Expression<Int64?>(type) <- str)
            }
            if item.values.first! == "Double" || item.values.first! == "Float" {
                let str = model.value(forKey: item.keys.first!) as? Double
                insertSetterArray.append(SQLite.Expression<Double?>(type) <- str)
            }
            if item.values.first! == "Bool" {
                let str = model.value(forKey: item.keys.first!) as! Bool
                insertSetterArray.append(SQLite.Expression<Bool?>(type) <- str)
            }
        }
        //特殊数据类型如字符,元组,结构体等 转为字符存储
        if model.disableArray != nil {
            for detailModelDic in model.disableArray! {
                let classNameStr = detailModelDic.values.first!
                if model.ignoreArray?.contains(detailModelDic.keys.first!) ?? false { continue }
                
                if classNameStr == "Character" {
                    let str = String(model.value(forKey: detailModelDic.keys.first!) as! Character)
                    let type = detailModelDic.keys.first!
                    insertSetterArray.append(SQLite.Expression<String>(type) <- str)
                } else {
                    let valueStr = model.disableArrayData(classNameStr: classNameStr, type: detailModelDic.keys.first!)
                    if valueStr != nil {
                        insertSetterArray.append(SQLite.Expression<String>(detailModelDic.keys.first!) <- valueStr!)
                    }
                }
            }
        }
        //模型
        if model.objectArray != nil {
            for (key, valueType) in model.objectArray! {
                insertSetterArray.append(SQLite.Expression<String>(key) <- valueType)
            }
        }
        //数组
        if model.modelArray != nil {
            for (key, valueType) in model.modelArray! {
                insertSetterArray.append(SQLite.Expression<String>(key) <- valueType)
            }
        }
        let insert = table.insert(insertSetterArray)
        do {
            MyLog("新增数据-----\(insert)")
            try DataBaseDB.run(insert)
        } catch  {
            MyLog(error.localizedDescription)
        }
        
        //子表插入数据,需要设置主键
        //模型
        if model.objectArray != nil {
            for (key, _) in model.objectArray! {
                var superTableID = ""
                if model.primaryKey == nil {
                    superTableID = "\(DataBaseDB.lastInsertRowid)"
                } else {
                    superTableID = model.value(forKey: model.primaryKey!) as! String
                }
                let detailModel = model.value(forKey: key) as! SuperModel
                detailModel.setValue(superTableID, forKey: "superTableID")
                insertData(model: detailModel, extStr: extStr)
            }
        }
        //数组
        if model.modelArray != nil {
            for (key, _) in model.modelArray! {
                let modelArray = model.value(forKey: key) as! [SuperModel]
                var superTableID = ""
                if model.primaryKey == nil {
                    superTableID = "\(DataBaseDB.lastInsertRowid)"
                } else {
                    superTableID = model.value(forKey: model.primaryKey!) as! String
                }
                for detailModel in modelArray {
                    detailModel.setValue(superTableID, forKey: "superTableID")
                    insertData(model: detailModel, extStr: extStr)
                }
            }
        }
    }
    
    /// 新增数据
    ///
    /// - Parameter modelArray: 数据模型数组
    func insertData(modelArray: [SuperModel], batchSize: Int = 500, extStr: String = "") {
        for i in stride(from: 0, to: modelArray.count, by: batchSize) {
            let batchModelArray = Array(modelArray[i..<min(i + batchSize, modelArray.count)])
            /// 保存主数据
            var subObjectArray: [SuperModel] = []
            var subModelArray: [SuperModel] = []
            
            do {
                try DataBaseDB.transaction {
                    for model in batchModelArray {
                        let table = Table(NSStringFromClass(type(of: model)) + extStr)
                        
                        //插入
                        var insertSetterArray = [Setter]()
                        //上表主键ID
                        let str = model.value(forKey: "superTableID") as? String
                        insertSetterArray.append(SQLite.Expression<String?>("superTableID") <- str)
                        
                        for item in model.classForCoder.get_class_copyPropertyList() {
                            let type = item.keys.first!
                            
                            if model.ignoreArray?.contains(type) ?? false { continue }
                            if item.values.first! == "NSString" {
                                let str = model.value(forKey: item.keys.first!) as? String
                                insertSetterArray.append(SQLite.Expression<String?>(type) <- str)
                            }
                            if item.values.first! == "Int" {
                                let str = model.value(forKey: item.keys.first!) as? Int64
                                insertSetterArray.append(SQLite.Expression<Int64?>(type) <- str)
                            }
                            if item.values.first! == "Double" || item.values.first! == "Float" {
                                let str = model.value(forKey: item.keys.first!) as? Double
                                insertSetterArray.append(SQLite.Expression<Double?>(type) <- str)
                            }
                            if item.values.first! == "Bool" {
                                let str = model.value(forKey: item.keys.first!) as! Bool
                                insertSetterArray.append(SQLite.Expression<Bool?>(type) <- str)
                            }
                        }
                        //特殊数据类型如字符,元组,结构体等 转为字符存储
                        if model.disableArray != nil {
                            for detailModelDic in model.disableArray! {
                                let classNameStr = detailModelDic.values.first!
                                if model.ignoreArray?.contains(detailModelDic.keys.first!) ?? false { continue }
                                
                                if classNameStr == "Character" {
                                    let str = String(model.value(forKey: detailModelDic.keys.first!) as! Character)
                                    let type = detailModelDic.keys.first!
                                    insertSetterArray.append(SQLite.Expression<String>(type) <- str)
                                } else {
                                    let valueStr = model.disableArrayData(classNameStr: classNameStr, type: detailModelDic.keys.first!)
                                    if valueStr != nil {
                                        insertSetterArray.append(SQLite.Expression<String>(detailModelDic.keys.first!) <- valueStr!)
                                    }
                                }
                            }
                        }
                        //模型
                        if model.objectArray != nil {
                            for (key, valueType) in model.objectArray! {
                                insertSetterArray.append(SQLite.Expression<String>(key) <- valueType)
                            }
                        }
                        //数组
                        if model.modelArray != nil {
                            for (key, valueType) in model.modelArray! {
                                insertSetterArray.append(SQLite.Expression<String>(key) <- valueType)
                            }
                        }
                        let insert = table.insert(insertSetterArray)
                        do {
                            try DataBaseDB.run(insert)
                        } catch  {
                            MyLog(error.localizedDescription)
                        }
                        
                        //子表插入数据,需要设置主键
                        //模型
                        if model.objectArray != nil {
                            for (key, _) in model.objectArray! {
                                var superTableID = ""
                                if model.primaryKey == nil {
                                    superTableID = "\(DataBaseDB.lastInsertRowid)"
                                } else {
                                    superTableID = model.value(forKey: model.primaryKey!) as! String
                                }
                                let detailModel = model.value(forKey: key) as! SuperModel
                                detailModel.setValue(superTableID, forKey: "superTableID")
                                subObjectArray.append(detailModel)
                                
    //                            insertData(model: detailModel, extStr: extStr)
                            }
                        }
                        //数组
                        if model.modelArray != nil {
                            for (key, _) in model.modelArray! {
                                let modelArray = model.value(forKey: key) as! [SuperModel]
                                var superTableID = ""
                                if model.primaryKey == nil {
                                    superTableID = "\(DataBaseDB.lastInsertRowid)"
                                } else {
                                    superTableID = model.value(forKey: model.primaryKey!) as! String
                                }
                                for detailModel in modelArray {
                                    detailModel.setValue(superTableID, forKey: "superTableID")
                                    subModelArray.append(detailModel)
                                    
    //                                insertData(model: detailModel, extStr: extStr)
                                }
                            }
                        }
                    }
                }
            } catch {
                MyLog(error.localizedDescription)
            }
            //处理子表内容
            if !subObjectArray.isEmpty {
                insertData(modelArray: subObjectArray, extStr: extStr)
            }
            if !subModelArray.isEmpty {
                insertData(modelArray: subModelArray, extStr: extStr)
            }
        }
    }
    
    //MARK: ----------数据查询-----------
    /// 查询表内所有数据
    ///
    /// - Parameter model: 检索模型
    /// - Returns: 查询结果
    func quertyAllData(model: SuperModel, extStr: String = "") -> [SuperModel]? {
        let table = Table(NSStringFromClass(type(of: model)) + extStr)
        return quertyData(model: model, table: table, extStr: extStr)
    }
    
    
    /// 查询筛选数据
    ///
    /// - Parameters:
    ///   - model: 检索的模型类
    ///   - parameters: 检索参数
    /// - Returns: 查询结果
    func quertyDetailData(model: SuperModel, parameters: [String]?, extStr: String = "") -> [SuperModel]? {
        var table = Table(NSStringFromClass(type(of: model)) + extStr)
        
        if parameters == nil {
            return quertyData(model: model, table: table, extStr: extStr)
        }
        
        var resultParameters: [String]? = parameters
        
        if model.ignoreArray != nil {
            for ignoreStr in model.ignoreArray! {
                resultParameters = parameters!.filter {$0 != ignoreStr}
            }
        }
        
        //父表ID
        if model.superTableID != nil {
            table = table.filter(SQLite.Expression<String>("superTableID") == model.superTableID!)
            resultParameters = parameters!.filter {$0 != "superTableID"}
        }
        
        //获取主键信息
        if model.primaryKey != nil {
            if resultParameters!.contains(model.primaryKey!) {
                table = table.filter(SQLite.Expression<String>(model.primaryKey!) == model.value(forKey: model.primaryKey!) as! String)
                return quertyData(model: model, table: table, extStr: extStr)
            }
            if resultParameters!.contains("primaryValue") {
                table = table.filter(SQLite.Expression<String>(model.primaryKey!) == model.value(forKey: "primaryValue") as! String)
                return quertyData(model: model, table: table, extStr: extStr)
            }
            
        } else {
            if resultParameters!.contains("primaryValue") {
                table = table.filter(SQLite.Expression<String>("dataBaseID") == model.value(forKey: "primaryValue") as! String)
                return quertyData(model: model, table: table, extStr: extStr)
            }
        }
        
        if model.primaryKey != nil {
            resultParameters = parameters!.filter {$0 != model.primaryKey!}
        }
        resultParameters = parameters!.filter {$0 != "primaryValue"}
        
        if resultParameters == nil {
            return quertyData(model: model, table: table, extStr: extStr)
        }
        
        for item in model.classForCoder.get_class_copyPropertyList() {
            let type = item.keys.first!
            let value = model.value(forKey: type)
            
            if resultParameters!.contains(type) {
                if value != nil {
                    if item.values.first! == "NSString" {
                        table = table.filter(SQLite.Expression<String>(type) == model.value(forKey: type) as! String)
                    }
                    if item.values.first! == "Int" {
                        table = table.filter(SQLite.Expression<Int64>(type) == model.value(forKey: type) as! Int64)
                    }
                    if item.values.first! == "Double" || item.values.first! == "Float" {
                        table = table.filter(SQLite.Expression<Double>(type) == model.value(forKey: type) as! Double)
                    }
                    if item.values.first! == "Bool" {
                        table = table.filter(SQLite.Expression<Bool>(type) == model.value(forKey: type) as! Bool)
                    }
                }
            }
        }
        return quertyData(model: model, table: table, extStr: extStr)
    }
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - model: 当前表
    ///   - table: 筛选条件
    /// - Returns: 结果
    private func quertyData(model: SuperModel, table:Table, extStr: String = "") -> [SuperModel]? {
        var resultModelArray = [SuperModel]()
        
        do {
            for modelRow in try! DataBaseDB.prepare(table) {
                let detaiModel = NSClassFromString(NSStringFromClass(type(of: model))) as! SuperModel.Type
                let resultModel = detaiModel.init()
                
                var primaryKeyValue = ""
                if model.primaryKey != nil {
                    primaryKeyValue = "\(modelRow[SQLite.Expression<String>(model.primaryKey!)])"
                } else {
                    primaryKeyValue = "\(modelRow[SQLite.Expression<Int64>("dataBaseID")])"
                }
                resultModel.setValue(primaryKeyValue, forKey: "primaryValue")
                
                //特殊数据类型如字符,元组,结构体等 转为字符存储
                if model.disableArray != nil {
                    for detailModelDic in model.disableArray! {
                        let classNameStr = detailModelDic.values.first!
                        let type = detailModelDic.keys.first!
                        
                        if model.ignoreArray?.contains(type) ?? false { continue }
                        
                        let value = modelRow[SQLite.Expression<String?>(type)]
                        if value == nil {
                            continue
                        }
                        if classNameStr == "Character" {
                            resultModel.setValue(value, forKey: type)
                        } else {
                            resultModel.setValue(model.disableArrayData(classNameStr: classNameStr, value: value!), forKey: type)
                        }
                    }
                }
                //模型
                if model.objectArray != nil {
                    for (key, valueType) in model.objectArray! {
                        let className = kkProjectName + "." + valueType
                        let detaiModel = NSClassFromString(className) as! SuperModel.Type
                        
                        let searchModel = detaiModel.init()
                        searchModel.superTableID = primaryKeyValue
                        //通过superTableID查询数据
                        let resultArray = quertyDetailData(model: searchModel, parameters: ["superTableID"], extStr: extStr)
                        if resultArray != nil {
                            resultModel.setValue(resultArray!.first, forKey: key)
                        }
                    }
                }
                //数组
                if model.modelArray != nil {
                    for (key, valueType) in model.modelArray! {
                        let className = kkProjectName + "." + valueType
                        let detaiModel = NSClassFromString(className) as! SuperModel.Type
                        
                        let searchModel = detaiModel.init()
                        searchModel.superTableID = primaryKeyValue
                        //通过superTableID查询数据
                        let resultArray = quertyDetailData(model: searchModel, parameters: ["superTableID"], extStr: extStr)
                        if resultArray != nil {
                            resultModel.setValue(resultArray!, forKey: key)
                        }
                    }
                }
                
                for item in model.classForCoder.get_class_copyPropertyList() {
                    if model.ignoreArray?.contains(item.keys.first!) ?? false { continue }
                    
                    if item.values.first! == "NSString" {
                        let type = item.keys.first!
                        let value = modelRow[SQLite.Expression<String?>(type)]
                        resultModel.setValue(value, forKey: type)
                    }
                    if item.values.first! == "Int" {
                        let type = item.keys.first!
                        let value = modelRow[SQLite.Expression<Int64?>(type)]
                        resultModel.setValue(value, forKey: type)
                    }
                    if item.values.first! == "Double" {
                        let type = item.keys.first!
                        let value = modelRow[SQLite.Expression<Double?>(type)]
                        resultModel.setValue(value, forKey: type)
                    }
                    if item.values.first! == "Float" {
                        let type = item.keys.first!
                        let value = modelRow[SQLite.Expression<Double?>(type)]
                        resultModel.setValue(value, forKey: type)
                    }
                    if item.values.first! == "Bool" {
                        let type = item.keys.first!
                        let value = modelRow[SQLite.Expression<Bool?>(type)]
                        resultModel.setValue(value, forKey: type)
                    }
                }
                resultModelArray.append(resultModel)
            }
        }
        return resultModelArray
    }
    
    //MARK: ----------数据更新-----------
    /// 更新数据,注意:如果设置关联表内容,子表中数据会先删除后新增.
    ///
    /// - Parameters:
    ///   - model: 检索模型
    ///   - newModel: 更新模型
    ///   - parameters: 检索参数
    ///   - newParameters: 需要更新模型的属性
    func updateData(model: SuperModel, newModel: SuperModel, parameters: [String]?, newParameters: [String]?, extStr: String = "") {
        if parameters == nil { return }
        
        var resultParameters: [String]? = parameters
        
        if model.ignoreArray != nil {
            for ignoreStr in model.ignoreArray! {
                resultParameters = parameters!.filter {$0 != ignoreStr}
            }
        }
        
        var table = Table(NSStringFromClass(type(of: model)) + extStr)
        
        if model.primaryKey == nil {
            if resultParameters?.contains("primaryValue") ?? false { //有主键值
                table = table.filter(SQLite.Expression<String>("dataBaseID") == model.value(forKey: "primaryValue") as! String)
                updateData(model: model, newModel: newModel, table: table, newParameters: newParameters, extStr: extStr)
            } else { //先查询主键
                let resultArray = quertyDetailData(model: model, parameters: resultParameters, extStr: extStr)
                for resultModel in resultArray! {
                    var table = Table(NSStringFromClass(type(of: resultModel)) + extStr)
                    if resultModel.primaryKey != nil {
                        table = table.filter(SQLite.Expression<String>(resultModel.primaryKey!) == resultModel.primaryValue)
                    } else {
                        table = table.filter(SQLite.Expression<String>("dataBaseID") == resultModel.primaryValue)
                    }
                    updateData(model: resultModel, newModel: newModel, table: table, newParameters: newParameters, extStr: extStr)
                }
            }
        } else {
            if resultParameters?.contains(model.primaryKey!) ?? false || resultParameters?.contains("primaryValue") ?? false { //有主键值
                if resultParameters?.contains("primaryValue") ?? false {
                    table = table.filter(SQLite.Expression<String>("dataBaseID") == model.value(forKey: "primaryValue") as! String)
                    updateData(model: model, newModel: newModel, table: table, newParameters: newParameters, extStr: extStr)
                } else {
                    table = table.filter(SQLite.Expression<String>(model.primaryKey!) == model.value(forKey: model.primaryKey!) as! String)
                    updateData(model: model, newModel: newModel, table: table, newParameters: newParameters, extStr: extStr)
                }
            } else { //先查询主键
                let resultArray = quertyDetailData(model: model, parameters: resultParameters, extStr: extStr)
                for resultModel in resultArray! {
                    var table = Table(NSStringFromClass(type(of: resultModel)) + extStr)
                    if resultModel.primaryKey != nil {
                        table = table.filter(SQLite.Expression<String>(resultModel.primaryKey!) == resultModel.primaryValue)
                    } else {
                        table = table.filter(SQLite.Expression<String>("dataBaseID") == resultModel.primaryValue)
                    }
                    updateData(model: resultModel, newModel: newModel, table: table, newParameters: newParameters, extStr: extStr)
                }
            }
        }
    }
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - model: 检索模型
    ///   - newModel: 新数据
    ///   - table: 表
    ///   - parameters: 检索参数
    private func updateData(model: SuperModel, newModel: SuperModel, table: Table, newParameters: [String]?, extStr: String = "") {
        var updateSetterArray = [Setter]()
        
        if newParameters != nil {
            for item in model.classForCoder.get_class_copyPropertyList() {
                let type = item.keys.first!
                
                if model.ignoreArray?.contains(type) ?? false { continue }
                if !(newParameters?.contains(type) ?? false) { continue }
                
                if item.values.first! == "NSString" {
                    let str = newModel.value(forKey: item.keys.first!) as? String
                    updateSetterArray.append(SQLite.Expression<String?>(type) <- str)
                }
                if item.values.first! == "Int" {
                    let str = newModel.value(forKey: item.keys.first!) as? Int64
                    updateSetterArray.append(SQLite.Expression<Int64?>(type) <- str)
                }
                if item.values.first! == "Double" || item.values.first! == "Float" {
                    let str = newModel.value(forKey: item.keys.first!) as? Double
                    updateSetterArray.append(SQLite.Expression<Double?>(type) <- str)
                }
                if item.values.first! == "Bool" {
                    let str = newModel.value(forKey: item.keys.first!) as! Bool
                    updateSetterArray.append(SQLite.Expression<Bool?>(type) <- str)
                }
            }
            
            //特殊数据类型如字符,元组,结构体等 转为字符存储
            if model.disableArray != nil {
                for detailModelDic in model.disableArray! {
                    let classNameStr = detailModelDic.values.first!
                    
                    if model.ignoreArray?.contains(detailModelDic.keys.first!) ?? false { continue }
                    if !(newParameters?.contains(detailModelDic.keys.first!) ?? false) { continue }
                    
                    if classNameStr == "Character" {
                        let str = String(newModel.value(forKey: detailModelDic.keys.first!) as! Character)
                        let type = detailModelDic.keys.first!
                        updateSetterArray.append(SQLite.Expression<String>(type) <- str)
                    } else {
                        let valueStr = newModel.disableArrayData(classNameStr: classNameStr, type: detailModelDic.keys.first!)
                        if valueStr != nil {
                            updateSetterArray.append(SQLite.Expression<String>(detailModelDic.keys.first!) <- valueStr!)
                        }
                    }
                }
            }
            
            let update = table.update(updateSetterArray)
            do {
                if try DataBaseDB.run(update) > 0 {
                    MyLog("数据更新成功")
                }
            } catch  {
                MyLog(error.localizedDescription)
            }
        }
        
        //模型,有主键
        if model.objectArray != nil && model.primaryValue != nil {
            for (key, valueType) in model.objectArray! {
                if newParameters?.contains(key) ?? false { //需要修改
                    //删除原有表数据
                    let className = kkProjectName + "." + valueType
                    let detaiModel = NSClassFromString(className) as! SuperModel.Type
                    let searchModel = detaiModel.init()
                    searchModel.superTableID = model.primaryValue
                    
                    deleteData(model: searchModel, parameters: ["superTableID"], extStr: extStr)
                    //新增
                    let value = newModel.value(forKey: key) as! SuperModel
                    value.superTableID = model.primaryValue
                    insertData(model: value, extStr: extStr)
                }
            }
        }
        //数组,有主键
        if model.modelArray != nil && model.primaryValue != nil  {
            for (key, valueType) in model.modelArray! {
                if newParameters?.contains(key) ?? false { //需要修改
                    //删除原有表数据
                    let className = kkProjectName + "." + valueType
                    let detaiModel = NSClassFromString(className) as! SuperModel.Type
                    let searchModel = detaiModel.init()
                    searchModel.superTableID = model.primaryValue
                    
                    deleteData(model: searchModel, parameters: ["superTableID"], extStr: extStr)
                    //新增
                    let valueArray = newModel.value(forKey: key) as! [SuperModel]
                    for value in valueArray {
                        value.superTableID = model.primaryValue
                        insertData(model: value, extStr: extStr)
                    }
                }
            }
        }
    }
    
    //MARK: ----------删除数据-----------
    /// 删除数据,会删除关联表数据
    ///
    /// - Parameters:
    ///   - model: 检索模型
    ///   - parameters: 检索参数
    func deleteData(model: SuperModel, parameters: [String]?, extStr: String = "") {
        if parameters == nil { return }
        
        var resultParameters: [String]? = parameters
        
        if model.ignoreArray != nil {
            for ignoreStr in model.ignoreArray! {
                resultParameters = parameters!.filter {$0 != ignoreStr}
            }
        }
        
        var table = Table(NSStringFromClass(type(of: model)) + extStr)
        
        if model.primaryKey == nil {
            if resultParameters?.contains("primaryValue") ?? false { //有主键值
                table = table.filter(SQLite.Expression<String>("dataBaseID") == model.value(forKey: "primaryValue") as! String)
                deleteData(model: model, table: table, extStr: extStr)
            } else { //先查询主键
                let resultArray = quertyDetailData(model: model, parameters: resultParameters, extStr: extStr)
                for resultModel in resultArray! {
                    var table = Table(NSStringFromClass(type(of: resultModel)) + extStr)
                    if resultModel.primaryKey != nil {
                        table = table.filter(SQLite.Expression<String>(resultModel.primaryKey!) == resultModel.primaryValue)
                    } else {
                        table = table.filter(SQLite.Expression<String>("dataBaseID") == resultModel.primaryValue)
                    }
                    deleteData(model: resultModel, table: table, extStr: extStr)
                }
            }
        } else {
            if resultParameters?.contains(model.primaryKey!) ?? false || resultParameters?.contains("primaryValue") ?? false { //有主键值
                if resultParameters?.contains("primaryValue") ?? false {
                    table = table.filter(SQLite.Expression<String>("dataBaseID") == model.value(forKey: "primaryValue") as! String)
                } else {
                    table = table.filter(SQLite.Expression<String>(model.primaryKey!) == model.value(forKey: model.primaryKey!) as! String)
                }
                deleteData(model: model, table: table, extStr: extStr)
            } else { //先查询主键
                let resultArray = quertyDetailData(model: model, parameters: resultParameters, extStr: extStr)
                for resultModel in resultArray! {
                    var table = Table(NSStringFromClass(type(of: resultModel)) + extStr)
                    if resultModel.primaryKey != nil {
                        table = table.filter(SQLite.Expression<String>(resultModel.primaryKey!) == resultModel.primaryValue)
                    } else {
                        table = table.filter(SQLite.Expression<String>("dataBaseID") == resultModel.primaryValue)
                    }
                    deleteData(model: resultModel, table: table, extStr: extStr)
                }
            }
        }
    }
    
    /// 删除表数据
    ///
    /// - Parameters:
    ///   - table: 表
    private func deleteData(model: SuperModel, table: Table, extStr: String = "") {
        let delete = table.delete()
        do {
            if try DataBaseDB.run(delete) > 0 {
                MyLog("数据删除成功")
            }
        } catch  {
            MyLog(error.localizedDescription)
        }
        
        if model.objectArray != nil {
            for (_, valueType) in model.objectArray! {
                //删除关联表数据
                let className = kkProjectName + "." + valueType
                let detaiModel = NSClassFromString(className) as! SuperModel.Type
                
                let searchModel = detaiModel.init()
                searchModel.superTableID = model.primaryValue
                deleteData(model: searchModel, parameters: ["superTableID"], extStr: extStr)
            }
        }
        //数组,有主键
        if model.modelArray != nil {
            for (_, valueType) in model.modelArray! {
                //删除关联表数据
                let className = kkProjectName + "." + valueType
                let detaiModel = NSClassFromString(className) as! SuperModel.Type
                
                let searchModel = detaiModel.init()
                searchModel.superTableID = model.primaryValue
                deleteData(model: searchModel, parameters: ["superTableID"], extStr: extStr)
            }
        }
    }
}

