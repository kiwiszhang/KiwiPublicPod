//
//  AlertViewBlock.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/17.
//

import UIKit
import SwiftUICore

typealias AlertActionBlock = (Bool) -> Void

func showAlertView(
    title: String,
    message: String,
    confirmButtonTitle: String = "Confirm",
    cancelButtonTitle: String = "Cancel",
    confirmButtonColor: String = "#007AFF",
    completion: @escaping AlertActionBlock
) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
        completion(false)
    }
    alert.addAction(cancelAction)
    
    let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
        completion(true)
    }
    confirmAction.setValue(kkColorFromHex(confirmButtonColor), forKey: "titleTextColor")
    alert.addAction(confirmAction)
    
    if let topViewController = UIApplication.topViewController() {
        topViewController.present(alert, animated: true, completion: nil)
    }
}

func showAlertViewWithOutCancelButton(
    title: String,
    message: String,
    confirmButtonTitle: String = "Confirm",
    completion: @escaping AlertActionBlock
) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
        completion(true)  // Pass 'true' to indicate Confirm was tapped
    }
    alert.addAction(confirmAction)
    
    if let topViewController = UIApplication.topViewController() {
        topViewController.present(alert, animated: true, completion: nil)
    }
}
