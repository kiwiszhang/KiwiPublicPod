//
//  Int+Extension.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/4/23.
//

import Foundation

extension Int {
    //屏幕宽高
    public var w: CGFloat {
        let standardWidth: CGFloat = 375
        let screenWidth = UIScreen.main.bounds.width
        return CGFloat(self) * (screenWidth / standardWidth)
    }

    public var h: CGFloat {
        let standardHeight: CGFloat = 812
        let screenHeight = UIScreen.main.bounds.height
        return CGFloat(self) * (screenHeight / standardHeight)
    }
}

public extension Int64 {
    /// 将秒级时间戳转成指定格式的日期字符串
    func toDateString(format: String = "MMM dd, yyyy",
                      timeZone: TimeZone = .current,
                      locale: Locale = Locale(identifier: "en_US_POSIX")) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: date)
    }
}
