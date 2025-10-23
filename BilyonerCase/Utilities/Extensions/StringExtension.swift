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
    
    func formattedToLocalString(dateStyle: DateFormatter.Style = .medium,
                                timeStyle: DateFormatter.Style = .short,
                                locale: Locale = Locale(identifier: "tr_TR")) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: self) ??
                        ISO8601DateFormatter().date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = dateStyle
        outputFormatter.timeStyle = timeStyle
        outputFormatter.locale = locale
        outputFormatter.timeZone = .current

        return outputFormatter.string(from: date)
    }
}
