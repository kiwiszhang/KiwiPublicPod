//
//  CustomPageCtrView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/4/22.
//

import UIKit
import SnapKit

public protocol PageControlViewDelegate: AnyObject {
    func pageControl(_ control: PageControlView, didSelectPageAt index: Int)
}

public struct PageControlViewConfig {
    let pageCount: Int
    var currentPage: Int
    let dotColor: UIColor
    let selectedDotColor: UIColor
    let spacing: CGFloat
    let animateDuration: Double
    
    public static let `default` = PageControlViewConfig(
        pageCount: 5,
        currentPage: 0,
        dotColor: .lightGray,
        selectedDotColor: .blue,
        spacing: 8.w,
        animateDuration: 0.3
    )
}

open class PageControlView: SuperView {
    open func setCurrentPage(_ page: Int, animated: Bool) {
        guard page >= 0, page < config.pageCount, page != config.currentPage else { return }

        let oldPage = config.currentPage
        config.currentPage = page
        if animated {
            UIView.animate(withDuration: config.animateDuration) {
                self.dots[oldPage].backgroundColor = self.config.dotColor
                self.dots[self.config.currentPage].backgroundColor = self.config.selectedDotColor
            }
        } else {
            dots[oldPage].backgroundColor = config.dotColor
            dots[config.currentPage].backgroundColor = config.selectedDotColor
        }
    }
    
    private var config = PageControlViewConfig.default
    
    weak var delegate: PageControlViewDelegate?
    private var dots = [UIView]()
    
    // MARK: - 初始化方法
    public convenience init(config: PageControlViewConfig = PageControlViewConfig.default) {
        self.init(frame: CGRect.zero)
        self.config = config
        setUpUI()
    }
    
    open override func setUpUI() {
        clipsToBounds = false
        recreateDots()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutDots()
    }
    
    private func recreateDots() {
        dots.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        
        for i in 0..<config.pageCount {
            let dot = UIView().tag(i).backgroundColor(i == config.currentPage ? config.selectedDotColor : config.dotColor)
            let tap = UITapGestureRecognizer(target: self, action: #selector(dotTapped(_:)))
            dot.addGestureRecognizer(tap)
            
            addSubview(dot)
            dots.append(dot)
        }
        
        layoutDots()
    }
    
    private func layoutDots() {
        guard !dots.isEmpty else { return }
        
        var previousDot: UIView?
        for dot in dots {
            dot.cornerRadius(dot.height / 2.0)
            dot.snp.remakeConstraints { make in
                make.height.equalTo(height)
                make.centerY.equalToSuperview()
                
                if let previous = previousDot {
                    make.leading.equalTo(previous.snp.trailing).offset(config.spacing)
                    make.width.equalTo(previous)
                } else {
                    make.leading.equalToSuperview()
                }
                // 最后一个点约束右边
                if dot == dots.last {
                    make.trailing.equalToSuperview()
                }
            }
            previousDot = dot
        }
    }
    
    @objc private func dotTapped(_ sender: UITapGestureRecognizer) {
        guard let dot = sender.view else { return }
        setCurrentPage(dot.tag, animated: true)
        delegate?.pageControl(self, didSelectPageAt: dot.tag)
    }
}
