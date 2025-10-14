//
//  NotificationCenterKeys.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/8.
//

import UIKit

class NotificationCenterKeys {
    
    enum CenterKeys:String {
        // 导入聊天后天后刷新页面
        case kCreatNewWrappedReloadView = "NotificationCenterKeys_kCreatNewWrappedReloadView"
        /// 挽留购买页模态消失
        case kModalDidDismiss = "NotificationCenterKeys_kModalDidDismiss"

        /// iCloud数据有变动通知
        case kICloudDataChanged = "NotificationCenterKeys_kICloudDataChanged"

        
    }

}
