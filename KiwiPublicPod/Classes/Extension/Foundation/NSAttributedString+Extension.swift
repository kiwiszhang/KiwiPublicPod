//
//  NSAttributedString+Extension.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/23.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static public func styled(
        baseString: String,
        defaultAttributes: [NSAttributedString.Key: Any] = [:],
        targets: [String] = [],
        attributes: [[NSAttributedString.Key: Any]] = []
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: baseString,
            attributes: defaultAttributes
        )
        
        guard targets.count == attributes.count else {
            MyLog("targets 和 attributes 数量不匹配，已忽略局部样式")
            return attributedString
        }
        
        for (index, target) in targets.enumerated() {
            let searchRange = NSRange(location: 0, length: baseString.utf16.count)
            var range = (baseString as NSString).range(of: target, range: searchRange)
        
            while range.location != NSNotFound {
                let combinedAttributes = defaultAttributes.merging(attributes[index]) { (_, new) in new }
                attributedString.addAttributes(combinedAttributes, range: range)
                
                let nextLocation = range.location + range.length
                range = (baseString as NSString).range(
                    of: target,
                    options: [],
                    range: NSRange(location: nextLocation, length: baseString.utf16.count - nextLocation)
                )
            }
        }
        
        return attributedString
    }
}

