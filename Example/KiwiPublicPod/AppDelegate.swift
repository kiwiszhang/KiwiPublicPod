//
//  AppDelegate.swift
//  KiwiPublicPod
//
//  Created by 张志强 on 09/28/2025.
//  Copyright (c) 2025 张志强. All rights reserved.
//

import UIKit
import KiwiPublicPod

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 全局黑色状态栏显示
        StatusBarManager.shared.isHidden = false
        StatusBarManager.shared.style = .lightContent
        StatusBarManager.shared.updateStatusBar()
        
        // 设置Tabbar
        setupTabBarAppearance()

        //创建表
        creatTable()
        // cloud处理
        iCloudHandle(application)
        
        // 创建 window
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = MainTabBarController()
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
private
extension AppDelegate {
    
    func iCloudHandle(_ application: UIApplication) {
        // 请求通知权限
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        // 注册订阅（比如监听 Person 表）
        CloudKitPhotoManager.creatSubscription(to: RecordType.personType.rawValue)
    }
    
    func creatTable(){
    }
}

