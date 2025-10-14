//
//  PersonModel.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/11/1.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

struct ExteriorStruct {
    var height: Float!
    var weight: Double!
}

enum Professional {
    case Student
    case IT
    case Education
    case Serve
    case Order
    case other
}

class PersonModel: SuperModel {
    var name: String?
    var email: String?
    var province: Character? 
    var height: Float = 0
    var weight: Double = 0
    var exterior: ExteriorStruct?
    var sex: Bool = false
    var education: EducationModel?
    var professional: Professional?
    
    override var ignoreArray: [String]? {
        get {
            return ["name", "exterior"]
        }
    }
    override var disableArray: [[String: String]]? {
        get {
            return [["province": "Character"], ["exterior": "ExteriorStruct"], ["professional": "Professional"]]
        }
    }
    override var objectArray: [String: String]? {
        get {
            return ["education": "EducationModel"]
        }
    }
    override func disableArrayData(classNameStr: String, type: String) -> String? {
        if classNameStr == "ExteriorStruct" {
            let structValue = value(forKey: type) as! ExteriorStruct
            let structValueStr = "\(structValue.height ?? 0),\(structValue.weight ?? 0)"
            return structValueStr
        }
        return nil
    }
    override func disableArrayData(classNameStr: String, value: String) -> Any? {
        if classNameStr == "ExteriorStruct" {
            let structArray = value.components(separatedBy: ",")
            let structValue = ExteriorStruct(height: Float(structArray[0]) ?? 0.00, weight: Double(structArray[1]) ?? 0.00)
            return structValue
        }
        return nil
    }
}
//MARK: ----------KVC-----------
extension PersonModel {
    override func value(forUndefinedKey key: String) -> Any? {
        if key == "province" {
            return province
        }
        if key == "exterior" {
            return exterior
        }
        return nil
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "province" {
            province = Character(value as! String)
        } else if key == "exterior" {
            let newValue = value as! ExteriorStruct
            exterior = ExteriorStruct.init(height: newValue.height, weight: newValue.weight)
        } else {
            super.setValue(value, forUndefinedKey: key)
        }
    }
}
