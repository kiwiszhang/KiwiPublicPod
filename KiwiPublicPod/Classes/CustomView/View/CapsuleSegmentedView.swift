//
//  PlayerTools.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/16.
//

import UIKit
import SnapKit

public struct CapsuleSegmentedStyle {

    public var backgroundColor: UIColor
    public var selectionColor: UIColor

    public var normalTextColor: UIColor
    public var selectedTextColor: UIColor

    public var normalFont: UIFont
    public var selectedFont: UIFont

    public var cornerRadius: CGFloat
    public var selectionCornerRadius: CGFloat

    public var shadowColor: UIColor
    public var shadowOpacity: Float
    public var shadowRadius: CGFloat

    public static let defaultStyle = CapsuleSegmentedStyle(
        backgroundColor: UIColor(white: 0.9, alpha: 1),
        selectionColor: .white,
        normalTextColor: .gray,
        selectedTextColor: .black,
        normalFont: .systemFont(ofSize: 14.h, weight: .regular),
        selectedFont: .systemFont(ofSize: 14.h, weight: .medium),
        cornerRadius: 18.h,
        selectionCornerRadius: 14.h,
        shadowColor: .black,
        shadowOpacity: 0.08,
        shadowRadius: 4
    )
}



open class CapsuleSegmentedView: UIView {

    // MARK: - Public
    private(set) var selectedIndex: Int = 0
    public var onValueChanged: ((Int) -> Void)?

    // MARK: - Private
    public let items: [String]
    public let style: CapsuleSegmentedStyle

    private let backgroundView = UIView()
    private let selectionView = UIView()
    private let stackView = UIStackView()

    private var buttons: [UIButton] = []
    private var selectionLeadingConstraint: Constraint?
    private let contentInset: CGFloat = 2

    // MARK: - Init
    public init(items: [String], style: CapsuleSegmentedStyle) {
        self.items = items
        self.style = style
        super.init(frame: .zero)
        setupUI()
        updateSelection(animated: false)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear

        // 外层背景
        backgroundView.backgroundColor = style.backgroundColor
        backgroundView.layer.cornerRadius = style.cornerRadius
        addSubview(backgroundView)

        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // 选中背景
        selectionView.backgroundColor = style.selectionColor
        selectionView.layer.cornerRadius = style.selectionCornerRadius
        selectionView.layer.shadowColor = style.shadowColor.cgColor
        selectionView.layer.shadowOpacity = style.shadowOpacity
        selectionView.layer.shadowRadius = style.shadowRadius
        selectionView.layer.shadowOffset = .zero
        backgroundView.addSubview(selectionView)

        selectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(contentInset)
            $0.bottom.equalToSuperview().inset(contentInset)

            $0.leading.equalToSuperview().offset(contentInset)
            $0.trailing.equalToSuperview().multipliedBy(0.5).offset(-contentInset)
        }



        // StackView
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        backgroundView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // Buttons
        items.enumerated().forEach { index, title in
            let button = UIButton(type: .system)
            button.tag = index
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = style.normalFont
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }

    // MARK: - Action
    @objc private func buttonTapped(_ sender: UIButton) {
        setSelectedIndex(sender.tag, animated: true)
        onValueChanged?(sender.tag)
    }

    // MARK: - Public API
    public func setSelectedIndex(_ index: Int, animated: Bool) {
        guard index >= 0, index < items.count else { return }
        selectedIndex = index
        updateSelection(animated: animated)
    }

    // MARK: - Update
    private func updateSelection(animated: Bool) {
        let availableWidth = bounds.width - contentInset * 2
        let segmentWidth = availableWidth / CGFloat(items.count)
        let offset = contentInset + CGFloat(selectedIndex) * segmentWidth

        selectionLeadingConstraint?.update(offset: offset)

        let updates = {
            self.buttons.enumerated().forEach { idx, btn in
                let isSelected = idx == self.selectedIndex

                btn.setTitleColor(
                    isSelected ? self.style.selectedTextColor
                               : self.style.normalTextColor,
                    for: .normal
                )

                btn.titleLabel?.font = isSelected
                    ? self.style.selectedFont
                    : self.style.normalFont
            }
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 0,
                options: [.curveEaseOut],
                animations: updates
            )
        } else {
            updates()
        }
    }



    public override func layoutSubviews() {
        super.layoutSubviews()
        updateSelection(animated: false)
    }
}

