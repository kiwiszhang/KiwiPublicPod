//
//  UserDefaultsTools.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/8.
//

import UIKit

class UserDefaultsTools {
    
    enum UserDefaultsTypeKeys:String {
        case isFirstInstallApp = "UserDefaultsTypeKeys_isFirstInstallApp"
        case isSkipValueSetting = "UserDefaultsTypeKeys_isSkipValueSetting"
        case isSkipValuePerson = "UserDefaultsTypeKeys_isSkipValuePerson"
        case isSkipValueGroup = "UserDefaultsTypeKeys_isSkipValueGroup"
        case isDiscountHidden = "UserDefaultsTypeKeys_isDiscountHidden"
        case isInviteShare = "UserDefaultsTypeKeys_isInviteShare"
        
        case historyListChatName = "UserDefaultsTypeKeys_historyListChatName"
        case chatCurrentSelfName = "UserDefaultsTypeKeys_chatCurrentSelfName"
        case reportOtherName = "UserDefaultsTypeKeys_reportOtherName"
    }
    
    /// 是否为第一次安装APP
    @UserDefault(UserDefaultsTypeKeys.isFirstInstallApp.rawValue, defaultValue: true)
    static var isFirstInstallApp: Bool
    
    /// skip按钮是否隐藏
    @UserDefault(UserDefaultsTypeKeys.isSkipValueSetting.rawValue, defaultValue: false)
    static var isSkipValueSetting: Bool
    
    /// Person skip按钮是否隐藏
    @UserDefault(UserDefaultsTypeKeys.isSkipValuePerson.rawValue, defaultValue: false)
    static var isSkipValuePerson: Bool
    
    /// Group skip按钮是否隐藏
    @UserDefault(UserDefaultsTypeKeys.isSkipValueGroup.rawValue, defaultValue: false)
    static var isSkipValueGroup: Bool
    
    /// 优惠显示控制
    @UserDefault(UserDefaultsTypeKeys.isDiscountHidden.rawValue, defaultValue: false)
    static var isDiscountHidden: Bool
    
    /// 是否分享邀请过
    @UserDefault(UserDefaultsTypeKeys.isInviteShare.rawValue, defaultValue: false)
    static var isInviteShare: Bool
    
    /// 历史聊天分析显示的聊天名
    @UserDefault(UserDefaultsTypeKeys.historyListChatName.rawValue, defaultValue: "")
    static var historyListChatName: String
    
    /// 当前分享的聊天是自己的名字
    @UserDefault(UserDefaultsTypeKeys.chatCurrentSelfName.rawValue, defaultValue: "KIKI")
    static var chatCurrentSelfName: String
    
    /// 报告页有的地方需要使用的别人名字
    @UserDefault(UserDefaultsTypeKeys.reportOtherName.rawValue, defaultValue: "")
    static var reportOtherName: String
    
    
    

    

}
