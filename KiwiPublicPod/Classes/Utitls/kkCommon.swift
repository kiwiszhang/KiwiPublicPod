//
//  Common.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/4/30.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
@_exported import SnapKit
// MARK: - 系统相关
/// 获取keyWindow
public func kkKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: { $0.isKeyWindow })
    } else {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}
/// 获取UIApplication.shared.delegate
public let kkAppDelegate = UIApplication.shared.delegate
/// 获取跟控制器
public func kkRootViewController() -> UIViewController? {
    UIApplication.shared.delegate?.window??.rootViewController
}
/// 获取APP名
public let kkAppName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
/// 获取APP版本
public let kkAppVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
/// 获取系统版本
public let kkSystemVersion = Float(UIDevice.current.systemVersion) ?? 0
/// 设备型号（iPhone15,2 等内部代号）
public var kkDeviceModelCode: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)),
                  encoding: .ascii)?
        .trimmingCharacters(in: .controlCharacters) ?? "Unknown"
}
/// build号
public var kkBuildNumber: String {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
}
/// 设备语言
public var kkLanguage: String {
    Locale.preferredLanguages.first ?? "Unknown"
}
/// 设备地区
public var kkRegion: String {
    Locale.current.regionCode ?? "Unknown"
}
public let kkiOSVersionLater = { kkSystemVersion >= $0 }
/// 设备名字
public let kkDeviceName = UIDevice.current.name
/// 获取项目名
public let kkProjectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
/// 设备ID
private var UUID: String {
    get {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        return (strRef! as String).replacingOccurrences(of: "-", with: "")
    }
}
/// 存在系统里面的设备ID
public var kkDeviceID: String {
    get {
        let deviceID = KeyChainManager.keyChainReadData(identifier: kkProjectName + Bundle.main.bundleIdentifier!)
        if deviceID == nil {
            let _ = KeyChainManager.keyChainSaveData(data: UUID, withIdentifier: kkProjectName + Bundle.main.bundleIdentifier!)
            return KeyChainManager.keyChainReadData(identifier: kkProjectName + Bundle.main.bundleIdentifier!) as! String
        }
        return deviceID as! String
    }
}


// MARK: - 尺寸相关
public let kkScreenWidth = UIScreen.main.bounds.size.width
public let kkScreenHeight = UIScreen.main.bounds.size.height
public let kkTABBAR_HEIGHT = 49.0
public let kkNAV_HEIGHT = 44.0

/// top安全区域
public let kkSAFE_AREA_TOP: CGFloat = {
    guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return 0
    }
    
    if #available(iOS 11.0, *) {
        return window.safeAreaInsets.top
    }
    return 0
}()
/// bottom 安全区域
public let kkSAFE_AREA_BOTTOM: CGFloat = {
    guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return 0
    }
    
    if #available(iOS 11.0, *) {
        return window.safeAreaInsets.bottom
    }
    return 0
}()

/// 状态栏高度
public let kkSTATUS_BAR_HEIGHT: CGFloat = {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return 0
    }
    if #available(iOS 13.0, *) {
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}()

/// 导航栏总高度（状态栏+导航栏）
public let kkNAVIGATION_BAR_HEIGHT = kkNAV_HEIGHT + kkSTATUS_BAR_HEIGHT

/// Tab栏总高度（Tab栏+底部安全区域）
public let kkTAB_BAR_TOTAL_HEIGHT = kkTABBAR_HEIGHT + kkSAFE_AREA_BOTTOM

/// 设备类型判断
public let kkIS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
public let kkIS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

/// 屏幕类型判断 是否有刘海屏
public let kkIS_IPHONE_X_SERIES: Bool = {
    guard kkIS_IPHONE else { return false }
    return kkSAFE_AREA_BOTTOM > 0
}()

// MARK: - 机型相关
public let kkScreen_max_length = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
public let kkScreen_min_length = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)


// MARK: - 颜色相关
public func kkColorFromRGBA(_ r: CGFloat, _ g: CGFloat, _ b:CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}
public func kkColorFromRGB(_ r: CGFloat, _ g: CGFloat, _ b:CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}
public func kkColorFromRandom() -> UIColor {
    return kkColorFromRGB(CGFloat(Int.random(in: 0...255)), CGFloat(Int.random(in: 0...255)), CGFloat(Int.random(in: 0...255)))
}
public func kkColorFromHexWithAlpha(_ hex: Int, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(((hex & 0xFF0000) >> 16)) / 255.0,
                   green: CGFloat(((hex & 0xFF00) >> 8)) / 255.0,
                   blue: CGFloat((hex & 0xFF)) / 255.0,
                   alpha: alpha)
}
public func kkColorFromHex(_ hex: Int) -> UIColor {
    return kkColorFromHexWithAlpha(hex, 1)
}
public func kkColorFromHexWithAlpha(_ hexString: String, _ alpha: CGFloat) -> UIColor {
    // 去掉空格、# 号
    var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
    if hex.hasPrefix("#") {
        hex.removeFirst()
    }
    
    // 确保长度是 6 位
    guard hex.count == 6, let hexValue = Int(hex, radix: 16) else {
        // 输入无效，返回默认颜色
        return UIColor.black.withAlphaComponent(alpha)
    }
    
    // 解析 RGB
    let red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
    let blue  = CGFloat(hexValue & 0x0000FF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}
public func kkColorFromHex(_ hex: String) -> UIColor {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if hexString.hasPrefix("#") {
        hexString.remove(at: hexString.startIndex)
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)
    
    // 根据十六进制字符串长度判断是否包含透明度
    switch hexString.count {
    case 8: // 包含透明度 #RRGGBBAA
        return UIColor(red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                  alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
        
    case 6: // 不包含透明度 #RRGGBB
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1)
        
    default: // 默认返回黑色
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

// MARK: - 文件相关
public let kkPathTemp = NSTemporaryDirectory()
public let kkPathDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
public let kkPathCache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first

// MARK: - 通知中心
private let kkNotificationCenter = NotificationCenter.default

public func kkNotification_add(observer: Any, selector: Selector, name: String) {
    kkNotificationCenter.addObserver(observer, selector: selector, name: Notification.Name(rawValue: name), object: nil)
}
public func kkNotification_post(name: String, object: Any?) {
    kkNotificationCenter.post(name: Notification.Name(rawValue: name), object: object)
}
public func kkNotification_remove(observer: Any, name: String) {
    kkNotificationCenter.removeObserver(observer, name: Notification.Name(rawValue: name), object: nil)
}

// MARK: - 判空相关
public func kkStringIsEmpty(_ str: String?) -> Bool {
    guard let s = str else { return true } // nil -> 空
    if s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true } // 去掉空格换行
    if s.lowercased() == "null" || s == "(null)" { return true } // 特殊字符串
    return false
}


//获取图片宽高比
public func imgRote(image: UIImage) -> Double {
    return image.size.width / image.size.height
}

/// 自定义Log
/// - Parameters:
///   - message: 打印信息
///   - file: 文件
///   - funcName: 方法名
///   - lineNum: 行数
public func MyLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    let fileName = (file as NSString).lastPathComponent
    //获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    // 要把路径最后的字符串截取出来
    let lastName = ((fileName as NSString).pathComponents.last ?? "")
    let StrErr = "[\(lastName)][\(funcName)][第\(lineNum)行] 🔥 \n\(message)"
#if DEBUG
    print("\(dformatter.string(from: now)) \(StrErr)")
#else

#endif
    
}

