//
//  MatchOdds.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation

struct Match: Decodable {
    let id: String
    let sportKey: String
    let sportTitle: String
    let commenceTime: String
    let homeTeam: String
    let awayTeam: String
    let bookmakers: [Bookmaker]
    var selectedOdd: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
        case selectedOdd
    }
}
