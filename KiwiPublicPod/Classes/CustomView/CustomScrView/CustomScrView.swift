//
//  CustomScrView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/17.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

enum CustomDataType: String {
    case Img = "Img"
    case TitleBtn = "TitleBtn"
    case Custom = "Custom"
    case Feature = "Feature"
}

@objc public protocol CustomScrViewDelegate: NSObjectProtocol {
    @objc optional func scrViewDidSelect(view: SuperView, index: NSInteger)
    @objc optional func scrViewDidEndDecelerating(view: SuperView, page: NSInteger)
    @objc optional func scrViewDidScr(view: SuperView, space: CGFloat)
}

public class CustomScrView: SuperView {
    //MARK: ----------定义属性-----------
    public weak var delegate: CustomScrViewDelegate?
    var ScroEnable: Bool? {
        didSet {
            customCollectionView!.isScrollEnabled = ScroEnable == true
        }
    }
    private var customCollectionView: UICollectionView?
    private var customDataType = CustomDataType.Img
    private var customPageEnable = true
    private var customEdgeMake = UIEdgeInsets.zero
    private var customItemSize = CGSize.zero
    private var customScrollDirection = UICollectionView.ScrollDirection.horizontal
    private var currentIndex = 0
    private var customNewDataArray = [Any]()
    //自定义视图
    private var customClassStr = "customClassStrcustomClassStr"
    //轮播
    private var customPageControl: UIPageControl?
    private var customPageControlFrame: CGRect?
    private var customStartBtn: UIButton?
    private var customStartBtnFrame: CGRect?
    private var customBtnBlock = {}
    private var customTimeSpace = 0.0
    private var customTimer: Timer?
    //按钮
    private var customBtnTuple = (UIColor.white, UIColor.white, UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12), UIEdgeInsets.zero)
    private var customBgViewTuple = (UIColor.white, UIColor.white, 0.0, UIEdgeInsets.zero)
    private var customLineViewTuple: (UIColor, UIEdgeInsets, CGFloat)?
    private var customItemWidth: CGFloat = 0.0
    private var selectIndex = 0
    private var lastSelectIndex = 0
    
    //MARK: ----------懒加载-----------
    public var dataArray: Array<Any>? {
        didSet {
            if dataArray == nil  { return }
            if dataArray!.isEmpty { return }
            
            if customPageControl != nil {
                if (customDataType == .Feature || customDataType == .Img) && dataArray!.count != 1 {
                    customPageControl!.isHidden = false
                    customPageControl!.numberOfPages = dataArray!.count
                } else {
                    customPageControl!.isHidden = true
                }
            }
            
            customNewDataArray = dataArray!
            if customDataType == .Img {
                customNewDataArray.append(dataArray!.first!)
                customNewDataArray.insert(dataArray!.last!, at: 0)
            }
            customCollectionView!.reloadData()
        }
    }
    
    /// 滚动单元格
    ///
    /// - Parameter index: 单元格索引
    func setCurrentIndex(_ index: NSInteger, animated: Bool = false) {
        if customDataType == .Feature { return }
        if customDataType == .Custom || customDataType == .Img {
            if animated {
                customCollectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: customScrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically, animated: true)
            } else {
                if customScrollDirection == .horizontal {
                    if customItemSize.equalTo(CGSize.zero) {
                        customCollectionView?.setContentOffset(CGPoint.init(x: customCollectionView!.width * CGFloat(index), y: 0), animated: false)
                    } else {
                        customCollectionView?.setContentOffset(CGPoint.init(x: customItemSize.width * CGFloat(index), y: 0), animated: false)
                    }
                } else {
                    if customItemSize.equalTo(CGSize.zero) {
                        customCollectionView?.setContentOffset(CGPoint.init(x: 0, y: customCollectionView!.height * CGFloat(index)), animated: false)
                    } else {
                        customCollectionView?.setContentOffset(CGPoint.init(x: 0, y: customItemSize.height * CGFloat(index)), animated: false)
                    }
                }
            }
            return
        }
        if customDataType == .TitleBtn {
            selectIndex = index
            if lastSelectIndex == selectIndex { return }
            let cell = customCollectionView!.cellForItem(at: IndexPath.init(item: selectIndex, section: 0))
            if cell == nil {
                customCollectionView?.scrollToItem(at: IndexPath.init(item: selectIndex, section: 0), at: customScrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically, animated: false)
            } else {
                autoCenter()
            }
            customCollectionView?.reloadItems(at: [IndexPath.init(item: selectIndex, section: 0), IndexPath.init(item: lastSelectIndex, section: 0)])
            lastSelectIndex = selectIndex
        }
    }
    //MARK: ----------系统方法-----------
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if dataArray != nil && customNewDataArray.count - dataArray!.count == 2 {
            currentIndex = 1
            if customScrollDirection == UICollectionView.ScrollDirection.horizontal {
                customCollectionView!.setContentOffset(CGPoint.init(x: CGFloat(currentIndex) * customCollectionView!.width, y: 0), animated: false)
            } else {
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: CGFloat(currentIndex) * customCollectionView!.height), animated: false)
            }
        }
    }
    
    //MARK: ----------初始化方法-----------
    /// 自定义SCR
    ///
    /// - Parameters:
    ///   - classStr: 单元格标识符
    ///   - pageEnable: 是否分页
    ///   - edgeMake: 偏移
    ///   - itemSize: 单元格大小
    ///   - direction: 滚动方向
    public init(classStr: String, pageEnable: Bool = true, edgeMake: UIEdgeInsets = .zero, itemSize: CGSize = CGSize.zero, direction: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal) {
        super.init(frame: .zero)
        customClassStr = classStr
        customPageEnable = pageEnable
        customEdgeMake = edgeMake
        customItemSize = itemSize
        customScrollDirection = direction
        customDataType = .Custom
    
        setUpUI(direction: customScrollDirection)
    }
    
    /// 自定义SCR
    ///
    /// - Parameters:
    ///   - startBtn: 开始按钮
    ///   - pageControl: 页码控制器
    ///   - btnFrame: 开始按钮位置
    ///   - pageControlFrame: 页码控制器位置
    ///   - direction: 滚动方向
    ///   - btnMethord: 按钮方法
    public init(startBtn: UIButton? = nil, pageControl: UIPageControl? = nil, btnFrame: CGRect? = CGRect.zero, pageControlFrame: CGRect? = CGRect.zero, direction: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal, btnMethord: @escaping () -> ()) {
        super.init(frame: .zero)
        customStartBtn = startBtn
        customStartBtnFrame = btnFrame
        customPageControl = pageControl
        customPageControlFrame = pageControlFrame
        customBtnBlock = btnMethord
        customPageEnable = true
        customScrollDirection = direction
        customDataType = .Feature
        customPageEnable = true
        
        if customStartBtn != nil && customStartBtnFrame != nil {
            customStartBtn?.addTarget(self, action: #selector(customStartBtnMethord), for: .touchUpInside)
        }
        setUpUI(direction: customScrollDirection)
    }
    
    /// 自定义SCR
    ///
    /// - Parameters:
    ///   - timeSpace: 定时器
    ///   - pageControl: 页码控制器
    ///   - pageControlFrame: 页码控制器位置
    ///   - direction: 滚动方向
    public init(timeSpace: Double = 0, pageControl: UIPageControl?, pageControlFrame: CGRect?, direction: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal) {
        super.init(frame: .zero)
        customTimeSpace = timeSpace
        customPageControl = pageControl
        customPageControlFrame = pageControlFrame
        customPageEnable = true
        customScrollDirection = direction
        customDataType = .Img
        customPageEnable = true
        
        if timeSpace > 0 {
            customTimer = Timer.scheduledTimer(timeInterval: timeSpace, target: self, selector: #selector(customTimerMethord), userInfo: nil, repeats: true)
            RunLoop.main.add(customTimer!, forMode: RunLoop.Mode.common)
        }
        setUpUI(direction: customScrollDirection)
    }
    
    /// 自定义SCR
    ///
    /// - Parameters:
    ///   - btnProprety: 元组(按钮文字颜色,按钮文字选中颜色,按钮文字大小,按钮选中文字大小,间距)
    ///   - bgViewProprety: 元祖(背景色,选中背景色,圆角,间距)
    ///   - lineViewProprety: 元组(线条颜色,间距)
    ///   - itemWidth: 按钮大小
    ///   - edgeMake: 偏移
    ///   - direction: 滚动方向
    
    public init(btnProprety: (UIColor, UIColor, UIFont, UIFont, UIEdgeInsets), bgViewProprety: (UIColor, UIColor, Double, UIEdgeInsets), lineViewProprety: (UIColor, UIEdgeInsets, CGFloat)?, itemWidth: CGFloat = 0, edgeMake: UIEdgeInsets = .zero, direction: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal) {
        super.init(frame: .zero)
        customBtnTuple = btnProprety
        customBgViewTuple = bgViewProprety
        customLineViewTuple = lineViewProprety
        customItemWidth = itemWidth
        customEdgeMake = edgeMake
        customScrollDirection = direction
        customDataType = .TitleBtn
        customPageEnable = false
        setUpUI(direction: customScrollDirection)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
//MARK: ----------其他-----------
extension CustomScrView {
    @objc private func customStartBtnMethord() {
        customBtnBlock()
    }
    /// 设置UI
    ///
    /// - Parameter direction: 滚动方向
    private func setUpUI(direction: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal) {
        backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = direction
        
        customCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kkScreenWidth, height: 100), collectionViewLayout: layout)
        customCollectionView!.backgroundColor = .clear
        customCollectionView!.delegate = self
        customCollectionView!.dataSource = self
        customCollectionView!.showsVerticalScrollIndicator = false
        customCollectionView!.showsHorizontalScrollIndicator = false
        customCollectionView!.bounces = false
        customCollectionView!.isPagingEnabled = customPageEnable
        
        addSubview(customCollectionView!)
        
        customCollectionView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if customPageControl != nil && customPageControlFrame != nil {
            addSubview(customPageControl!)
            customPageControl!.snp.makeConstraints({ (make) in
                make.height.equalTo(customPageControlFrame!.size.height)
                make.top.equalToSuperview().offset(customPageControlFrame!.origin.y)
                make.centerX.equalToSuperview()
                make.width.equalTo(customPageControlFrame!.size.width)
            })
        }
        
        switch customDataType {
        case .TitleBtn:
            customCollectionView?.registerCells(CustomScrViewTitleCollectionViewCell.self)
        case .Custom:
            let className: AnyClass? = NSClassFromString(kkProjectName + "." + customClassStr)
            customCollectionView?.registerCells(className.self as! UICollectionViewCell.Type)
        default:
            customCollectionView?.registerCells(CustomScrViewImgCollectionViewCell.self)
        }
    }
    
    /// 更新单独Cell
    ///
    /// - Parameter index: Cell索引
    func upDate(index: NSInteger) {
        customCollectionView!.reloadItems(at: [IndexPath.init(item: index, section: 0)])
    }
    
    /// 更新所有Cell
    func upDate() {
        customCollectionView!.reloadData()
    }
    
    /// 定时器
    @objc private func customTimerMethord() {
        if customScrollDirection == UICollectionView.ScrollDirection.horizontal {
            if currentIndex == customNewDataArray.count - 2 {
                currentIndex = 0
                customCollectionView!.setContentOffset(CGPoint.init(x: CGFloat(currentIndex) * customCollectionView!.width, y: 0), animated: false)
                
                currentIndex = 1
                customCollectionView!.setContentOffset(CGPoint.init(x: CGFloat(currentIndex) * customCollectionView!.width, y: 0), animated: true)
            } else {
                currentIndex += 1
                customCollectionView!.setContentOffset(CGPoint.init(x: CGFloat(currentIndex) * customCollectionView!.width, y: 0), animated: true)
            }
        } else {
            if currentIndex == customNewDataArray.count - 2 {
                currentIndex = 0
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: CGFloat(currentIndex) * customCollectionView!.height), animated: false)
                
                currentIndex = 1
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: CGFloat(currentIndex) * customCollectionView!.height), animated: true)
            } else {
                currentIndex += 1
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: CGFloat(currentIndex) * customCollectionView!.height), animated: true)
            }
        }
    }
    
    /// 滚动到中间
    private func autoCenter() {
        let cell = customCollectionView!.cellForItem(at: IndexPath.init(item: selectIndex, section: 0))
        let cellColRect = customCollectionView!.convert(cell!.frame, to: customCollectionView!)
        let cellWinFrame = customCollectionView!.convert(cell!.frame, to: self)
        
        if customScrollDirection == UICollectionView.ScrollDirection.horizontal {
            //不滚动
            if customCollectionView!.contentSize.width <= customCollectionView!.width {
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                return
            }
            if cellColRect.origin.x + cellColRect.size.width / 2.0 < customCollectionView!.width / 2.0 {
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                return
            }
            if cellColRect.origin.x + cellColRect.size.width / 2.0 + customCollectionView!.width / 2.0 > customCollectionView!.contentSize.width {
                customCollectionView!.setContentOffset(CGPoint.init(x: customCollectionView!.contentSize.width - customCollectionView!.width, y: 0), animated: true)
                return
            }
            //滚动
            if cellWinFrame.origin.x + cellWinFrame.size.width / 2.0 >= customCollectionView!.width / 2.0 {//左侧
                let space = cellWinFrame.origin.x + cellWinFrame.size.width / 2.0 - customCollectionView!.width / 2.0
                customCollectionView!.setContentOffset(CGPoint.init(x: customCollectionView!.contentOffset.x + space, y: 0), animated: true)
            } else {
                let space = customCollectionView!.width / 2.0 - (cellWinFrame.origin.x + cellWinFrame.size.width / 2.0)
                customCollectionView!.setContentOffset(CGPoint.init(x: customCollectionView!.contentOffset.x - space, y: 0), animated: true)
            }
        } else {
            //不滚动
            if customCollectionView!.contentSize.height <= customCollectionView!.height {
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                return
            }
            if cellColRect.origin.y + cellColRect.size.height / 2.0 < customCollectionView!.height / 2.0 {
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                return
            }
            if cellColRect.origin.y + cellColRect.size.height / 2.0 + customCollectionView!.height / 2.0 > customCollectionView!.contentSize.height {
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: customCollectionView!.contentSize.height - customCollectionView!.height), animated: true)
                return
            }
            //滚动
            if cellWinFrame.origin.y + cellWinFrame.size.height / 2.0 >= customCollectionView!.height / 2.0 {//左侧
                let space = cellWinFrame.origin.y + cellWinFrame.size.height / 2.0 - customCollectionView!.height / 2.0
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: customCollectionView!.contentOffset.y + space), animated: true)
            } else {
                let space = customCollectionView!.height / 2.0 - (cellWinFrame.origin.y + cellWinFrame.size.height / 2.0)
                customCollectionView!.setContentOffset(CGPoint.init(x: 0, y: customCollectionView!.contentOffset.y - space), animated: true)
            }
        }
    }
}
//MARK: ----------CollectionViewDelegateDataSource-----------
extension CustomScrView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !customPageEnable { return }
        let page = customScrollDirection == UICollectionView.ScrollDirection.horizontal ? scrollView.contentOffset.x / scrollView.width : scrollView.contentOffset.y / scrollView.height
        selectIndex = max(0, Int(page))
        if delegate?.responds(to: #selector(CustomScrViewDelegate.scrViewDidEndDecelerating(view:page:))) ?? false {
            delegate?.scrViewDidEndDecelerating?(view: self, page: selectIndex)
        }
        
        if customDataType == .Img {
            if customScrollDirection == UICollectionView.ScrollDirection.horizontal {
                let page = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width
                if Int(page) == customNewDataArray.count - 1 {
                    scrollView.setContentOffset(CGPoint.init(x: scrollView.width, y: 0), animated: false)
                }
                if Int(page) == 0 {
                    scrollView.setContentOffset(CGPoint.init(x: CGFloat(customNewDataArray.count - 2) * scrollView.width, y: 0), animated: false)
                }
            } else {
                let page = (scrollView.contentOffset.y + scrollView.height * 0.5) / scrollView.height
                if Int(page) == customNewDataArray.count - 1 {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: scrollView.height), animated: false)
                }
                if Int(page) == 0 {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: CGFloat(customNewDataArray.count - 2) * scrollView.height), animated: false)
                }
            }
        }else if customDataType == .Custom {
//            centerCurrentCell()
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate?.responds(to: #selector(CustomScrViewDelegate.scrViewDidScr(view:space:))) ?? false {
            delegate?.scrViewDidScr?(view: self, space: customScrollDirection == UICollectionView.ScrollDirection.horizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y)
        }
        
        if !customPageEnable { return }
        if customDataType != .Img && customDataType != .Feature { return }
        if customScrollDirection == UICollectionView.ScrollDirection.horizontal {
            let page = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width
            currentIndex = max(0, Int(page))
        } else {
            let page = (scrollView.contentOffset.y + scrollView.height * 0.5) / scrollView.height
            currentIndex = max(0, Int(page))
        }
        customPageControl?.currentPage = customDataType == .Feature ? currentIndex : currentIndex - 1
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if customTimer != nil || customTimeSpace == 0 || !customPageEnable { return }
        customTimer = Timer.scheduledTimer(timeInterval: customTimeSpace, target: self, selector: #selector(customTimerMethord), userInfo: nil, repeats: true)
        RunLoop.main.add(customTimer!, forMode: RunLoop.Mode.common)
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if customTimer == nil { return }
        customTimer!.invalidate()
        customTimer = nil
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if customDataType == .Feature {
            let cell = collectionView.visibleCells.last as! CustomScrViewImgCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            if indexPath!.item == customNewDataArray.count - 1 {
                cell.upDateStartBtn(customStartBtn, btnFrame: customStartBtnFrame)
            }
        }
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customNewDataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch customDataType {
        case .TitleBtn:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScrViewTitleCollectionViewCell", for: indexPath) as! CustomScrViewTitleCollectionViewCell
            cell.upDateCell(btnProprety: customBtnTuple, bgViewProprety: customBgViewTuple, lineViewProprety: customLineViewTuple, btnTitle: customNewDataArray[indexPath.item] as! String, select: (selectIndex == indexPath.item))
            return cell
        case .Custom:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customClassStr, for: indexPath) as! CustomScrViewCustomCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScrViewImgCollectionViewCell", for: indexPath) as! CustomScrViewImgCollectionViewCell
            cell.imgName = customNewDataArray[indexPath.item] as? String
            return cell
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch customDataType {
        case .Img:
            if indexPath.item == 0 {
                selectIndex = dataArray!.count - 1
            } else if indexPath.item == customNewDataArray.count - 1 {
                selectIndex = 0
            } else {
                selectIndex = indexPath.item - 1
            }
        case .TitleBtn:
            if lastSelectIndex == indexPath.item { return }
            selectIndex = indexPath.item
            
            autoCenter()
            collectionView.reloadItems(at: [indexPath, IndexPath.init(item: lastSelectIndex, section: 0)])
            lastSelectIndex = selectIndex
        default:
            selectIndex = indexPath.item
        }
        
        if delegate?.responds(to: #selector(CustomScrViewDelegate.scrViewDidSelect(view:index:))) ?? false {
            delegate?.scrViewDidSelect?(view: self, index: selectIndex)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if customDataType == .Custom {
            (cell as! CustomScrViewCustomCollectionViewCell).upDataCell(dataArray: customNewDataArray, indexPath: indexPath)
        }
    }
}
//MARK: ----------UICollectionViewDelegateFlowLayout-----------
extension CustomScrView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if customDataType == .TitleBtn {
            let textStr = customNewDataArray[indexPath.row] as! NSString
            if customScrollDirection == UICollectionView.ScrollDirection.horizontal {
                if customItemWidth != 0 { return CGSize.init(width: customItemWidth, height: height) }
                return CGSize.init(width: textStr.size(withAttributes: [NSAttributedString.Key.font : customBtnTuple.3]).width + customBtnTuple.4.left + customBtnTuple.4.right + customBgViewTuple.3.left + customBgViewTuple.3.right + 5, height: height)
            } else {
                if customItemWidth != 0 { return CGSize.init(width: width, height: customItemWidth) }
                return CGSize.init(width: width, height: textStr.size(withAttributes: [NSAttributedString.Key.font : customBtnTuple.3]).height + customBtnTuple.4.top + customBtnTuple.4.bottom + customBgViewTuple.3.top + customBgViewTuple.3.bottom + 5)
            }
        }
        if customItemSize.equalTo(CGSize.zero) {
            return CGSize.init(width: width, height: height)
        }
        return customItemSize
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return customEdgeMake
    }
}

public extension CustomScrView {
    
    /// 设置左右 inset，让 cell 居中
    func setCarouselInsets() {
        guard let collectionView = customCollectionView else { return }
        let sideInset = (collectionView.frame.width - (customItemSize.width > 0 ? customItemSize.width : collectionView.frame.width)) / 2
        customEdgeMake = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        collectionView.contentInset = customEdgeMake
        collectionView.decelerationRate = .fast
    }
    
    /// 开启自动轮播
    func startAutoScroll(interval: TimeInterval) {
        customTimer?.invalidate()
        customTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(customTimerMethord), userInfo: nil, repeats: true)
        RunLoop.main.add(customTimer!, forMode: .common)
    }
    
    /// 停止自动轮播
    func stopAutoScroll() {
        customTimer?.invalidate()
        customTimer = nil
    }
    
    /// 滚动结束后自动居中当前 cell
    private func centerCurrentCell() {
        guard let collectionView = customCollectionView else { return }
        let visibleCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        var closestCell: UICollectionViewCell?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for cell in collectionView.visibleCells {
            let cellCenterX = cell.frame.midX
            let distance = abs(cellCenterX - visibleCenterX)
            if distance < minDistance {
                minDistance = distance
                closestCell = cell
            }
        }
        
        if let cell = closestCell, let indexPath = collectionView.indexPath(for: cell) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            selectIndex = indexPath.item
        }
    }
}
