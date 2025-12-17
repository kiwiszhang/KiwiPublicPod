//
//  Widget02ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/11/4.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget06ViewController: SuperViewController, UIScrollViewDelegate {
            
    // MARK: -  =====================lazyload=========================
    lazy var segmentedView = CapsuleSegmentedView(items: [], style: .defaultStyle)

        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTabView()
    }
    
    private func setupTabView() {
        var style = CapsuleSegmentedStyle.defaultStyle
        style.selectedTextColor = .systemBlue
        style.normalFont = UIFont.interBase(size: 14.h, weight: .mediumBase)
        style.selectedFont = UIFont.interBase(size: 14.h, weight: .mediumBase)
        
        segmentedView = CapsuleSegmentedView(
            items: ["summarize","transcription"],
            style: style
        )
        segmentedView.onValueChanged = { index in
            MyLog(index)
        }

        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100.h)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(260.w)
            $0.height.equalTo(36.h)
        }
    }

    // MARK: - =====================actions==========================
   
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}






