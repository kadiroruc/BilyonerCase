//
//  OddsButton.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//
import UIKit

final class OddsButton: UIButton {
    
    private let bottomView = UIView()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        bottomView.backgroundColor = .gray
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
    }
    
    func setOddTitle(odd: String, label: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center
        
        let title = NSMutableAttributedString(
            string: "\(odd)\n\(label)",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .paragraphStyle: paragraphStyle
            ]
        )
        title.addAttributes(
            [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 10)
            ],
            range: NSRange(location: odd.count + 1, length: label.count)
        )
        setAttributedTitle(title, for: .normal)
    }
}

