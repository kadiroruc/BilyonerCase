//
//  Market.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation

struct Market: Decodable {
    let key: String
    let last_update: String
    let outcomes: [Outcome]?
}
