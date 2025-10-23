//
//  Bookmaker.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation

struct Bookmaker: Decodable {
    let key: String
    let title: String
    let last_update: String
    let markets: [Market]
}
