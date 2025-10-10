//
//  NotificationManager.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/22.
//
import UserNotifications
import UIKit

final class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// 请求通知权限
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    MyLog("✅ 通知权限已允许")
                } else {
                    MyLog("❌ 通知权限被拒绝")
                }
            }
        }
    }
    
    /// 发送本地通知
    /// - Parameters:
    ///   - title: 通知标题
    ///   - body: 通知内容
    ///   - delay: 多少秒后触发
    func scheduleNotification(title: String, body: String, delay: TimeInterval = 3) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                MyLog("❌ 添加通知失败: \(error.localizedDescription)")
            } else {
                MyLog("📌 通知已安排在 \(delay) 秒后触发")
            }
        }
    }
    
    /// 取消所有通知
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        MyLog("🗑 所有通知已取消")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound]) // iOS 10~13 用 .alert
        }
    }

    
    /// 点击通知时回调
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        MyLog("👉 用户点击了通知: \(response.notification.request.identifier)")
//        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        completionHandler()
    }
}

