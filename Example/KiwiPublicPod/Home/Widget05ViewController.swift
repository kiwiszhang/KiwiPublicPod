//
//  Widget02ViewController.swift
//  KiwiPublicPod_Example
//
//  Created by 笔尚文化 on 2025/11/4.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class Widget05ViewController: SuperViewController, UIScrollViewDelegate {
    
    let tabView = CustomScrViewList()
        var collectionView: UICollectionView!
        
        private let titles = ["头条", "热点热点", "视频热点热点热点", "科技", "体育", "娱乐", "财经"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            setupTabView()
            setupCollectionView()
        }
        
        private func setupTabView() {
            tabView.titles = titles
            tabView.delegate = self
            view.addSubview(tabView)
            tabView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
            }
        }
        
        private func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height - 44 - view.safeAreaInsets.top)
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .white
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
            
            view.addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(tabView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }

    // MARK: - =====================actions==========================
   
    
    // MARK: - =====================delegate==========================
    
    
    // MARK: - =====================Deinit==========================

}

// MARK: - UICollectionViewDataSource & Delegate
extension Widget05ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
        let colors: [UIColor] = [.red, .green, .blue, .orange]
        cell.bgView.backgroundColor = colors[indexPath.item % colors.count]
        cell.label.text = titles[indexPath.item]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        tabView.selectIndex(index: page, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        tabView.selectIndex(index: page, animated: true)
    }
}

// MARK: - CustomScrViewListDelegate
extension Widget05ViewController: CustomScrViewListDelegate {
    func scrViewDidSelect(index: Int) {
        collectionView.layoutIfNeeded()
        if let attributes = collectionView.layoutAttributesForItem(at: IndexPath(item: index, section: 0)) {
            collectionView.scrollRectToVisible(attributes.frame, animated: true)
        }
    }
}


// MARK: - UICollectionViewCell
class ContentCell: UICollectionViewCell {
    let bgView = UIView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







