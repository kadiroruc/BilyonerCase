//
//  LeagueModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation

struct League: Decodable {
    let key: String
    let group: String
    let title: String
    let description: String
    let active: Bool
    let has_outrights: Bool
}
