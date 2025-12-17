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

    lazy var buttom00 = UILabel().text("弹框选择").backgroundColor(.systemCyan).color(.systemRed).fontSize(32).onTap {
        let menu = PopupMenu(
            items: [
                .init(title: "Edit Summary", icon: UIImage(named: "edit_summary")),
                .init(title: "Edit Transcript", icon: UIImage(named: "edit_transcript")),
                .init(title: "Transcription", icon: UIImage(named: "translate")),
                .init(title: "Translate", icon: UIImage(named: "delete"), isDestructive: true)
            ]
        )
//        menu.cornerRadius = 30.h
//        menu.menuWidth = 300.w
//        menu.rowHeight = 66.h
        menu.show(at: CGPoint(x: kkScreenWidth - 16.w, y: 88.h)) { index in
            print("点击了第 \(index) 项")
        }
    }
        
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
        
        view.addSubview(buttom00)
        buttom00.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(segmentedView.snp.bottom).offset(50)
        }
        
    }

    // MARK: - =====================actions==========================
   
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}






