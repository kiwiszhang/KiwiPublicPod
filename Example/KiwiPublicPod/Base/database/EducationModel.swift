//
//  EducationModel.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/11/1.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class EducationModel: SuperModel {
    var ID: String!
    var totalNum: NSInteger = 0
    var educationDetail: [EducationDetailModel]?
    override var primaryKey: String! {
        get {
            return "ID"
        }
    }
    override var modelArray: [String: String]? {
        get {
            return ["educationDetail": "EducationDetailModel"]
        }
    }
}
