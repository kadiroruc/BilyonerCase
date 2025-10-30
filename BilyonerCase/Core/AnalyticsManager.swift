//
//  AnalyticsManager.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 27.10.2025.
//

import FirebaseAnalytics

enum AnalyticsEvent {
    case addToCart(matchID: String, oddType: String, value: String)
    case removeAllFromCart(bets: [MatchBet])
}

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}

    func log(_ event: AnalyticsEvent) {
        switch event {

        case .addToCart(let matchID, let oddType, let value):
            Analytics.logEvent("add_to_cart", parameters: [
                "match_id": matchID,
                "odd_type": oddType,
                "odd_value": value
            ])

        case .removeAllFromCart(let bets):
            let removedItems = bets.map {
                "\($0.match.id):\($0.oddType)=\($0.value)"
            }.joined(separator: "; ")

            Analytics.logEvent("remove_from_cart", parameters: [
                "removed_items": removedItems,
                "total_removed_count": bets.count
            ])
        }
    }
}

