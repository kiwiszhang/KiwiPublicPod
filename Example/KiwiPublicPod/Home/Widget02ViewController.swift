//
//  Widget02ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/11/4.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget02ViewController: SuperViewController {
    
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
        
        // 1️⃣ 图片轮播
        setupBanner()

        // 2️⃣ 标题标签栏
        setupTabBar()

        // 3️⃣ 自定义 cell
        setupCustom()

        // 4️⃣ 新手引导页
        setupGuide()
        
        setUpUI()
        getData()
    }
    
    // MARK: - ===================Intial Methods=======================
    override func setUpUI() {

    }
    
    override func getData() {
        
    }
    // MARK: - =====================actions==========================
    // MARK: - 1. 轮播图
    private func setupBanner() {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray

        let banner = CustomScrView(
            timeSpace: 2.0,
            pageControl: pageControl,
            pageControlFrame: CGRect(x: 0, y: 180, width: 200, height: 20),
            direction: .horizontal
        )

        banner.dataArray = ["1", "2", "3","4"] // 资源名 (项目里放同名图片)
        banner.delegate = self

        view.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(200)
        }
    }

    // MARK: - 2. 标题栏
    private func setupTabBar() {
        let titles = ["推荐", "视频视频", "热点", "娱乐视频视频", "体育", "科技"]
        let tabBar = CustomScrView(
            btnProprety: (.darkGray, .red,
                          .systemFont(ofSize: 14),
                          .boldSystemFont(ofSize: 16),
                          .init(top: 0, left: 8, bottom: 0, right: 8)),
            bgViewProprety: (.clear, .clear, 0, .zero),
            lineViewProprety: nil,
            itemWidth: 0, // 自动计算宽度
            edgeMake: .init(top: 0, left: 10, bottom: 0, right: 10),
            direction: .horizontal
        )
        tabBar.dataArray = titles
        tabBar.delegate = self
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(220)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }

//        // 配置按钮属性
        let btnTuple = (UIColor.black, UIColor.red, UIFont.systemFont(ofSize: 14), UIFont.boldSystemFont(ofSize: 16), UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        let bgTuple = (UIColor.white, UIColor.lightGray, 8.0, UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))

        // 创建 CustomScrView（标题按钮）
        let scrView = CustomScrView(btnProprety: btnTuple, bgViewProprety: bgTuple, lineViewProprety: nil, itemWidth: 80,edgeMake: .init(top: 0, left: 10, bottom: 0, right: 10),direction: .horizontal)

        // 设置代理
        scrView.delegate = self

        // 添加数据
        scrView.dataArray = titles

        // 添加到父视图
        view.addSubview(scrView)
        scrView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(280)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

    }

    // MARK: - 3. 自定义 cell
    private func setupCustom() {
//        let customView = CustomScrView(
//            classStr: "MyCustomCell",
//            itemSize: CGSize(width: 100, height: 100),   // cell尺寸
//            direction: .horizontal
//        )
//
//        customView.dataArray = ["A", "B", "C", "D","8","9","0","4"]   // 数据源
//        customView.delegate = self
//
//        view.addSubview(customView)
//        customView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(350)
//            make.left.equalToSuperview().offset(50)
//            make.right.equalToSuperview().offset(-50)
//            make.height.equalTo(120)
//        }
//
//        // 设置左右 inset，让第一个和最后一个 cell 可以居中显示
//        DispatchQueue.main.async {
//            customView.setCarouselInsets()
//            customView.startAutoScroll(interval: 3)  // 自动轮播
//        }
        
        // 自定义 Cell 类名，必须继承自 CustomScrViewCustomCollectionViewCell
        let scrView = CustomScrView(classStr: "MyCustomCell", pageEnable: false, edgeMake: .zero, itemSize: CGSize(width: 100, height: 100))

        // 设置代理
        scrView.delegate = self

        // 添加数据
        scrView.dataArray = ["A", "B", "C", "D","8","9","0","4"]

        // 添加到父视图
        view.addSubview(scrView)
        scrView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(350)
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }

    }

    // MARK: - 4. 引导页
    private func setupGuide() {
        let startBtn = UIButton(type: .system)
        startBtn.setTitle("立即体验", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.backgroundColor = .blue
        startBtn.layer.cornerRadius = 20

        let pageControl = UIPageControl()

        let guideView = CustomScrView(
            startBtn: startBtn,
            pageControl: pageControl,
            btnFrame: CGRect(x: 0, y: 200, width: 300, height: 40),
            pageControlFrame: CGRect(x: 0, y: 150, width: 200, height: 20),
            direction: .horizontal
        ) {
            print("👉 点击了立即体验按钮")
        }

        guideView.dataArray = ["1", "2", "3","4"]

        view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(480)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

// MARK: - 代理
extension Widget02ViewController: CustomScrViewDelegate {
    func scrViewDidSelect(view: SuperView, index: NSInteger) {
        print("✅ 点击 index:", index)
    }
    func scrViewDidEndDecelerating(view: SuperView, page: NSInteger) {
        print("📌 当前页:", page)
    }
}

// MARK: - 自定义 cell 示例
class MyCustomCell: CustomScrViewCustomCollectionViewCell {
    private lazy var bgView = UIView().backgroundColor(.systemRed)
    private lazy var label = UILabel()
    override func setUpUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.textAlignment = .center
        label.backgroundColor(.systemTeal)
        label.font = .boldSystemFont(ofSize: 18)
        bgView.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.center.equalToSuperview()
        }
    }

    override func upDataCell(dataArray: [Any], indexPath: IndexPath) {
        label.text = "\(dataArray[indexPath.item])"
    }
}
