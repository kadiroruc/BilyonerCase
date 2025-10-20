//
//  UITextFieldExtension.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 16.10.2025.
//

import UIKit

extension UITextField {
    func addBottomBorder(color: UIColor = .lightGray, height: CGFloat = 1.0) {
        self.borderStyle = .none

        // Önce varsa kaldır
        self.layer.sublayers?.removeAll(where: { $0.name == "bottomBorder" })

        let border = CALayer()
        border.name = "bottomBorder"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        self.layer.addSublayer(border)
    }

    func updateBottomBorderFrame(height: CGFloat = 1.0) {
        guard let border = self.layer.sublayers?.first(where: { $0.name == "bottomBorder" }) else { return }
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
    }
}

