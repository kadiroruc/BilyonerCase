//
//  OddsAPI.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation
import Alamofire

enum OddsAPI: Endpoint {
    private static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("OddsAPIKey not found in Info.plist")
        }
        return key
    }

    case getLeagues
    case getMatches(leagueKey: String)

    var baseURL: String { "https://api.the-odds-api.com/v4/sports" }

    var path: String {
        switch self {
        case .getLeagues: return "/"
        case .getMatches(let leagueKey): return "/\(leagueKey)/odds/"
        }
    }

    var method: HTTPMethod { .get }

    var parameters: Parameters? {
        switch self {
        case .getLeagues:
            return ["apiKey": OddsAPI.apiKey]
        case .getMatches:
            return [
                "apiKey": OddsAPI.apiKey,
                "regions": "us",
                "markets": "h2h",
                "oddsFormat": "decimal"
            ]
        }
    }
}



