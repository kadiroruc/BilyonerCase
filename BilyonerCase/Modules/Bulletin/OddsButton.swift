//
//  OddsButton.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//
import UIKit

// MARK: - Constants

fileprivate enum Layout {
    static let cornerRadius: CGFloat = 8
    static let bottomViewHeightMultiplier: CGFloat = 0.45
}

fileprivate enum Typography {
    static let oddFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let labelFont = UIFont.systemFont(ofSize: 10)
    static let lineSpacing: CGFloat = 2
}

fileprivate enum Colors {
    static let backgroundColor = UIColor.white
    static let bottomViewColor = UIColor.gray
    static let oddTextColor = UIColor.black
    static let labelTextColor = UIColor.white
}

// MARK: - OddsButton

final class OddsButton: UIButton {
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = Colors.bottomViewColor
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.accessibilityIdentifier = "OddsButton.bottomView"
        return bottomView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        self.layer.cornerRadius = Layout.cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = Colors.backgroundColor
        
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Layout.bottomViewHeightMultiplier),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
    }
    
    func setOddTitle(odd: String, label: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Typography.lineSpacing
        paragraphStyle.alignment = .center
        
        let title = NSMutableAttributedString(
            string: "\(odd)\n\(label)",
            attributes: [
                .foregroundColor: Colors.oddTextColor,
                .font: Typography.oddFont,
                .paragraphStyle: paragraphStyle
            ]
        )
        title.addAttributes(
            [
                .foregroundColor: Colors.labelTextColor,
                .font: Typography.labelFont
            ],
            range: NSRange(location: odd.count + 1, length: label.count)
        )
        setAttributedTitle(title, for: .normal)
    }
    
    func setSelectedTop(_ selected: Bool) {
        if selected && backgroundColor == .systemGreen{
            backgroundColor = .white
        }
        backgroundColor = selected ? .systemGreen : .white
    }

    func resetSelection() {
        setSelectedTop(false)
    }
}

