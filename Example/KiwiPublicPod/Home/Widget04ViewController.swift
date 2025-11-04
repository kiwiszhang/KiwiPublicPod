//
//  Widget02ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/11/4.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget04ViewController: SuperViewController {
    
    // MARK: - =====================lazy load=======================
    private lazy var animationV = UIView()
    private lazy var videoView: VideoPlayerView? = nil

    // MARK: - =====================life cycle=======================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        getData()
        
        self.view.addChildView([animationV])
        animationV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(270.h)
        }
        
        let mp4Video = Bundle.main.url(forResource: Files.Videos.newGuid0Mp4.name, withExtension: "mp4")
        guard let mp4VideoUrl = mp4Video else { return }
        videoView = VideoPlayerView(fileURL: mp4VideoUrl)
        animationV.addSubview(videoView!)
        videoView?.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        videoView?.play()

    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================
   
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}
