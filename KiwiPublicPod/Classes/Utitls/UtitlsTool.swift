//
//  UtitlsTool.swift
//  KiwiPublicPod
//
//  Created by 笔尚文化 on 2025/12/12.
//

import UIKit

public class UtitlsTool {
    /// 时间戳转：Apr 10,2025 10:30 am这种格式的时间
    public func timestampToFormattedString(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM dd, yyyy  hh:mm a"   // Apr 10, 2025  10:30 AM

        return formatter.string(from: date).lowercased() // am/pm 变为小写
    }


}
