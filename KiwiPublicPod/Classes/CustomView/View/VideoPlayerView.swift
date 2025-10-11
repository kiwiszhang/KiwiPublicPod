//
//  PlayerTools.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/16.
//

import UIKit
import AVKit

open class VideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserver: Any?
    private var fileURL: URL?
    
    // MARK: - 初始化
    public init(fileURL: URL? = nil) {
        self.fileURL = fileURL
        super.init(frame: .zero)
        setupPlayer(with: fileURL)
        setupNotifications()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cleanupPlayer()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 播放器设置
    private func setupPlayer(with fURL: URL? = nil) {
        guard let fileURL = fURL else{ return}
        let playerItem = AVPlayerItem(url: fileURL)
        player = AVPlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer!)
        
        // 循环播放通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    // MARK: - 播放控制
    open func play() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    open func pause() {
        player?.pause()
    }
    
    private func cleanupPlayer() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    // MARK: - 循环播放
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        player?.seek(to: .zero) { [weak self] finished in
            if finished {
                self?.player?.play()
            }
        }
    }
    
    // MARK: - App 状态监听
    @objc private func appDidEnterBackground() {
        pause()
    }
    
    @objc private func appDidBecomeActive() {
        play()
    }
}

