//
//  LinearProgressView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/4/23.
//

import UIKit

struct LinearProgressViewConfig {
    let progressColor: UIColor
    let trackColor: UIColor
    let animateDuration: Double
    
    static let `default` = LinearProgressViewConfig(
        progressColor: .blue,
        trackColor: .lightGray,
        animateDuration: 0.3
    )
}

open class LinearProgressView: SuperView {
    private var config = LinearProgressViewConfig.default
    private var progress: CGFloat = 0 {
        didSet { updateProgress() }
    }
    
    private lazy var trackView = UIView()
    private lazy var progressView = UIView()
    
    // MARK: - 初始化方法
    convenience init(config: LinearProgressViewConfig = LinearProgressViewConfig.default) {
        self.init(frame: CGRect.zero)
        self.config = config
        setUpUI()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        trackView.cornerRadius(height/2)
        progressView.cornerRadius(height/2)
    }
    open override func setUpUI() {
        trackView.backgroundColor(config.trackColor)
        addSubview(trackView)
        
        progressView.backgroundColor(config.progressColor)
        addSubview(progressView)
        
        trackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(progress)
        }
    }
    
    private func updateProgress() {
        progressView.snp.remakeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(progress)
        }
        UIView.animate(withDuration: config.animateDuration, delay: 0, options: .curveEaseOut) {
            [weak self] in
            guard let self = self else {return}
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - 公开方法
    open func setProgress(_ value: CGFloat, animated: Bool = true) {
        let clampedValue = max(0, min(1, value))
        if animated {
            self.progress = clampedValue
        } else {
            UIView.performWithoutAnimation {
                self.progress = clampedValue
            }
        }
    }
    
    func updateConfig(_ config: LinearProgressViewConfig) {
        self.config = config
        trackView.backgroundColor(config.trackColor)
        progressView.backgroundColor(config.progressColor)
    }
}

