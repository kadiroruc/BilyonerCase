//
//  BulletinViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation
import RxSwift

protocol BulletinViewModelDelegate: AnyObject {
    var view: BulletinViewDelegate? { get set }
    var leagues: [League] { get }
    var matches: [Match] { get }
    var betSelected: PublishSubject<MatchBet> { get }
    
    func fetchLeagues()
    func fetchMatches(leagueKey: String)
    func selectBet(_ bet: MatchBet)
    func clearAllSelectedOdds()
}

// MARK: - BulletinViewModel

final class BulletinViewModel {

    weak var view: BulletinViewDelegate?
    private let apiClient: APIClientDelegate
    private let disposeBag = DisposeBag()

    var leagues: [League] = []
    var matches: [Match] = []
    let betSelected = PublishSubject<MatchBet>()
    private var selectedOdds: [String: String] = [:]

    init(apiClient: APIClientDelegate) {
        self.apiClient = apiClient
    }
    
}

// MARK: - BulletinViewModelDelegate

extension BulletinViewModel: BulletinViewModelDelegate{
    
    func fetchLeagues() {
        view?.showLoading(true)
        apiClient.request(OddsAPI.getLeagues, type: [League].self)
            .subscribe(onSuccess: { [weak self] leagues in
                guard let self = self else { return }
                
                self.view?.showLoading(false)
                self.leagues = leagues.filter({ $0.has_outrights == false })
                self.view?.showLeagues(self.leagues)
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                
                self.view?.showLoading(false)
                self.view?.showError(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

    func fetchMatches(leagueKey: String) {
        view?.showLoading(true)
        apiClient.request(OddsAPI.getMatches(leagueKey: leagueKey), type: [Match].self)
            .subscribe(onSuccess: { [weak self] matches in
                guard let self = self else { return }
                
                self.view?.showLoading(false)
                self.matches = matches
                self.restoreSelectedOdds()
                self.view?.showMatches()
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                
                self.view?.showLoading(false)
                self.view?.showError(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func selectBet(_ bet: MatchBet) {
        updateMatchWithSelectedOdd(bet)
        
        if let index = matches.firstIndex(where: { $0.id == bet.match.id }) {
            let updatedMatch = matches[index]
            let updatedBet = MatchBet(match: updatedMatch, oddType: bet.oddType, value: bet.value)
            betSelected.onNext(updatedBet)
        } else {
            betSelected.onNext(bet)
        }
        
        AnalyticsManager.shared.log(.addToCart(matchID: bet.match.id, oddType: bet.oddType, value: bet.value))
    }
    
    private func updateMatchWithSelectedOdd(_ bet: MatchBet) {
        if let index = matches.firstIndex(where: { $0.id == bet.match.id }) {
            var updatedMatch = matches[index]
        
            let isCurrentlySelected = updatedMatch.selectedOdd == bet.oddType
            
            if isCurrentlySelected {
                updatedMatch.selectedOdd = nil
                selectedOdds.removeValue(forKey: bet.match.id)
            } else {
                updatedMatch.selectedOdd = bet.oddType
                selectedOdds[bet.match.id] = bet.oddType
            }
            
            matches[index] = updatedMatch
        }
    }
    
    private func restoreSelectedOdds() {
        for (index, match) in matches.enumerated() {
            if let selectedOdd = selectedOdds[match.id] {
                var updatedMatch = match
                updatedMatch.selectedOdd = selectedOdd
                matches[index] = updatedMatch
            }
        }
    }
    
    func clearAllSelectedOdds() {
        selectedOdds.removeAll()
        for (index, match) in matches.enumerated() {
            var updatedMatch = match
            updatedMatch.selectedOdd = nil
            matches[index] = updatedMatch
        }
        view?.showMatches()
    }
}
