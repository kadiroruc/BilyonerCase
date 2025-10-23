//
//  UIButtonExtension.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//

import UIKit

extension UIButton {
    
    func setSplitBackgroundOdd(odd: String?, label: String) {

        layer.sublayers?.removeAll(where: { $0.name == "splitLayer" })
        
        let upperView = UIView()
        upperView.backgroundColor = .white
        upperView.translatesAutoresizingMaskIntoConstraints = false
        upperView.isUserInteractionEnabled = false
        
        let lowerView = UIView()
        lowerView.backgroundColor = .systemGray
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.isUserInteractionEnabled = false
        
        addSubview(upperView)
        addSubview(lowerView)
        sendSubviewToBack(upperView)
        sendSubviewToBack(lowerView)
        
        NSLayoutConstraint.activate([
            upperView.topAnchor.constraint(equalTo: topAnchor),
            upperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            upperView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            lowerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lowerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lowerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
        ])
        
        let fullText = NSMutableAttributedString()
        if let odd = odd {
            let oddAttr = NSAttributedString(
                string: "\(odd)\n",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                    .foregroundColor: UIColor.black
                ]
            )
            fullText.append(oddAttr)
        }
        
        let labelAttr = NSAttributedString(
            string: label,
            attributes: [
                .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
        )
        fullText.append(labelAttr)
        
        self.setAttributedTitle(fullText, for: .normal)
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
    }
}

