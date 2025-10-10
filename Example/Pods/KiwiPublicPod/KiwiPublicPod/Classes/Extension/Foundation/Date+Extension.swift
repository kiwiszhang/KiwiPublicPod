//
//  Date+Extension.swift
//  MobileProgect
//
//  Created by 于晓杰 on 2021/3/22.
//  Copyright © 2021 于晓杰. All rights reserved.
//

import UIKit

//MARK: ----------扩展-----------
extension Date {
    /// 日期转字符
    /// - Parameters:
    ///   - date: 日期
    ///   - format: 格式
    /// - Returns: 字符
    static public func dateToStr(date: Date, format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: date)
    }
    
    
    /// 字符转日期
    /// - Parameters:
    ///   - dateStr: 日期字符串
    ///   - format: 格式
    /// - Returns: 日期
    static public func strToDate(dateStr: String, format: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        if let date = dateFormat.date(from: dateStr) {
            return date
        } else {
            return Date()
        }
    }
    
    
    /// 计算两个时间差
    /// - Parameters:
    ///   - starDateStr: 开始时间
    ///   - endDateStr: 结束时间
    ///   - format: 格式
    /// - Returns: 差值
    static public func dateSpace(starDateStr: String, endDateStr: String, format: String = "M/d/yy HH:mm:ss") -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        if let startTime = dateFormatter.date(from: starDateStr),
           let endTime = dateFormatter.date(from: endDateStr) {
            let timeDifference = endTime.timeIntervalSince(startTime)
            return Int(timeDifference)
        } else {
            return 0
        }
    }
}
