//
//  PlayerTools.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/16.
//

import UIKit

public class DashedBorderView: UIView {
    public var cornerRadius:CGFloat
    public var lineWidth:CGFloat
    public var lineDashPattern: [NSNumber]
    public var strokeColor: UIColor
    public init(cornerRadius: CGFloat = 10,lineWidth:CGFloat = 1,lineDashPattern:[NSNumber] = [4,2],strokeColor: UIColor = .systemTeal) {
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.lineDashPattern = lineDashPattern
        self.strokeColor = strokeColor
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0 else { return }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        addDashedBorder(cornerRadius: cornerRadius,lineWidth: lineWidth,lineDashPattern: lineDashPattern,strokeColor: strokeColor)
    }
}

//public final class DashedBorderView: UIView {
//
//    private let contentView = UIView()
//    private let borderLayer = CAShapeLayer()
//
//    public var cornerRadius: CGFloat = 10 {
//        didSet { setNeedsLayout() }
//    }
//
//    public var lineWidth: CGFloat = 1 {
//        didSet { setNeedsLayout() }
//    }
//
//    public var lineDashPattern: [NSNumber] = [4, 2] {
//        didSet { setNeedsLayout() }
//    }
//
//    public var strokeColor: UIColor = .systemTeal {
//        didSet { borderLayer.strokeColor = strokeColor.cgColor }
//    }
//
//    // 👇 对外暴露背景色
//    public override var backgroundColor: UIColor? {
//        get { contentView.backgroundColor }
//        set { contentView.backgroundColor = newValue }
//    }
//
//    public init(cornerRadius: CGFloat = 10,lineWidth:CGFloat = 1,lineDashPattern:[NSNumber] = [4,2],strokeColor: UIColor = .systemTeal) {
//        self.cornerRadius = cornerRadius
//        self.lineWidth = lineWidth
//        self.lineDashPattern = lineDashPattern
//        self.strokeColor = strokeColor
//        super.init(frame: .zero)
//        setup()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        super.backgroundColor = .clear
//
//        addSubview(contentView)
//        contentView.layer.masksToBounds = true
//
//        borderLayer.fillColor = UIColor.clear.cgColor
//        layer.addSublayer(borderLayer)
//    }
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let inset = lineWidth
//        let contentRect = bounds.insetBy(dx: inset, dy: inset)
//
//        contentView.frame = contentRect
//        contentView.layer.cornerRadius = cornerRadius
//
//        borderLayer.frame = bounds
//        borderLayer.lineWidth = lineWidth
//        borderLayer.lineDashPattern = lineDashPattern
//        borderLayer.strokeColor = strokeColor.cgColor
//
//        borderLayer.path = UIBezierPath(
//            roundedRect: contentRect,
//            cornerRadius: cornerRadius
//        ).cgPath
//    }
//}

extension UIView {
    func addDashedBorder(
        cornerRadius: CGFloat,
        lineWidth: CGFloat = 1,
        lineDashPattern: [NSNumber] = [6, 3],
        strokeColor: UIColor = .red
    ) {
        layer.sublayers?
            .filter { $0.name == "DashedBorderLayer" }
            .forEach { $0.removeFromSuperlayer() }
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedBorderLayer"
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = lineDashPattern
        let inset = lineWidth / 2
        let rect = bounds.insetBy(dx: inset, dy: inset)
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(
            roundedRect: rect,
            cornerRadius: max(0, cornerRadius - inset)
        ).cgPath
        layer.addSublayer(shapeLayer)
    }
}
