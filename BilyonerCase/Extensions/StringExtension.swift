//
//  StringExtension.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 17.10.2025.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}
