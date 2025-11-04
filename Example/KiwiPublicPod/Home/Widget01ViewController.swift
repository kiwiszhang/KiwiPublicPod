//
//  Widget01ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/10/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget01ViewController: SuperViewController ,PageControlViewDelegate{
    lazy var comtents = [
        GuidBannerItem(topImage:Asset.guidStar.image,date: "June 26,2025", title: "L10n.helpfulForTaxs", comment: "L10n.exportingReportsFor"),
        GuidBannerItem(topImage:Asset.guidStar.image,date: "June 23,2025", title: "L10n.efficient", comment: "L10n.noMoreManual"),
        GuidBannerItem(topImage:Asset.guidStar.image,date: "June 28,2025", title: "L10n.fastAndSimple", comment: "L10n.superIntuitive"),
    ]
    lazy var banner = GuidBannerView(frame: CGRect(x: 0, y: 0, width: kkScreenWidth, height: 112.h),items: comtents).backgroundColor(.clear)
    
    
    lazy var buttom00 = UILabel().text("bottom00").backgroundColor(.systemCyan).color(.systemRed).fontSize(32).onTap {
        showAlertView(title: "title",message: "message", confirmButtonTitle:"buttonTitle01", cancelButtonTitle: "buttonTitle00",confirmButtonColor: "#FF3B30") { confirmed in
            if confirmed {
                // 用户点击确认
            } else {
                // 用户点击取消
            }
        }
    }
    lazy var buttom01 = UILabel().text("bottom01").backgroundColor(.systemCyan).color(.systemRed).fontSize(32).onTap {
        showAlertViewWithOutCancelButton(title: "title",message: "message", confirmButtonTitle:"ok") {confirmed in
            
        }
    }
    
    lazy var popView = UILabel().text("popView").backgroundColor(.systemCyan).color(.systemRed).fontSize(32).onTap {
        let content = WidgetViewController()
//        content.delegate = self
        let popup = PopupContainerViewController(contentVC: content, height: kkScreenHeight - 60.h)
        content.dismissAction = {
            popup.dismissSelf()
        }
        self.present(popup, animated: false)
    }
    // MARK: - =====================lazy load=======================
    
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
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {
        view.addSubview(banner)
        view.addSubview(buttom00)
        view.addSubview(buttom01)
        banner.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(112.h)
            make.top.equalToSuperview().offset(50.h)
        }
        
        buttom00.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(banner.snp.bottom).offset(50)
        }
        buttom01.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(banner.snp.bottom).offset(50)
        }
        
        
        let customConfig = LinearProgressViewConfig(
            progressColor: .systemGreen,
            trackColor: .systemGray5,
            animateDuration: 0.5
        )
        let progressView = LinearProgressView(config: customConfig)

        // 添加进度条
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(buttom00.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(8)
        }
        // 模拟进度变化
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            progressView.setProgress(0.3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            progressView.setProgress(0.6)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            progressView.setProgress(1.0)
        }
        
        
        let config = PageControlViewConfig(
            pageCount: 7,
            currentPage: 2,
            dotColor: .systemGray4,
            selectedDotColor: .systemBlue,
            spacing: 10,
            animateDuration: 0.25
        )

        let pageControl = PageControlView(config: config)
        pageControl.delegate = self
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(8)
            make.width.equalTo(120)
        }

        view.addSubview(popView)
        popView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(pageControl.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        
        let titles = ["左图", "右图", "上图", "下图"]
        let types: [CustomButtonType] = [.Left, .Right, .Up, .Down]
        let icons = ["takePic", "takePic", "takePic", "takePic"]
        for (index, type) in types.enumerated() {
            let btn = CustomButton(type: .custom)
            btn.setImage(UIImage(named: icons[index]), for: .normal)
            btn.setTitle(titles[index], for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.customBtnType = type
            btn.paddingSpace = 6
            btn.backgroundColor = UIColor.systemGray6
            btn.layer.cornerRadius = 8
            btn.addTarget(self, action: #selector(onTapShare), for: .touchUpInside)
            view.addSubview(btn)
            
            btn.snp.makeConstraints { make in
                make.width.equalTo(140)
                make.height.equalTo(90)
                make.centerX.equalToSuperview()
                make.top.equalTo(popView.snp.bottom).offset(10 + index * 100)
            }
            btn.setNeedsLayout()
            btn.layoutIfNeeded()

        }

    }
    
    override func getData() {
        banner.didSelectItem = { index, item in
            print("点击了第 \(index) 个 item: \(item.title)")
        }
    }
    // MARK: - =====================actions==========================
    @objc private func onTapShare() {
        print("👉 点击了分享按钮")
    }
    
    // MARK: - =====================delegate==========================
    func pageControl(_ control: PageControlView, didSelectPageAt index: Int) {
        print("👉 用户点击了第 \(index) 页")
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
//        pageControl.setCurrentPage(page, animated: true)
//    }
//    
//    func pageControl(_ control: PageControlView, didSelectPageAt index: Int) {
//        // 点击 dot 手动滚动
//        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.frame.width, y: 0), animated: true)
//    }
    // MARK: - =====================Deinit==========================

}

//MARK: ----------TableViewDelegateDataSource-----------
