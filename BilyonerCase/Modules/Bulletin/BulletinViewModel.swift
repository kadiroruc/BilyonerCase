//
//  BulletinViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation
import RxSwift

protocol BulletinViewModelProtocol: AnyObject {
    var view: BulletinViewProtocol? { get set }
    var leagues: [League] { get }
    var matches: [Match] { get }
    var betSelected: PublishSubject<MatchBet> { get }
    
    func fetchLeagues()
    func fetchMatches(leagueKey: String)
    func selectBet(_ bet: MatchBet)
}

final class BulletinViewModel: BulletinViewModelProtocol {

    weak var view: BulletinViewProtocol?
    private let apiClient: APIClientProtocol
    private let disposeBag = DisposeBag()

    var leagues: [League] = []
    var matches: [Match] = []
    let betSelected = PublishSubject<MatchBet>()
    private var selectedOdds: [String: String] = [:]

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchLeagues() {
        view?.showLoading(true)
        apiClient.request(OddsAPI.getLeagues, type: [League].self)
            .subscribe(onSuccess: { [weak self] leagues in
                self?.view?.showLoading(false)
                self?.leagues = leagues.filter({ $0.has_outrights == false })
                self?.view?.showLeagues(self?.leagues ?? [])
            }, onFailure: { [weak self] error in
                self?.view?.showLoading(false)
                self?.view?.showError(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

    func fetchMatches(leagueKey: String) {
        view?.showLoading(true)
        apiClient.request(OddsAPI.getMatches(leagueKey: leagueKey), type: [Match].self)
            .subscribe(onSuccess: { [weak self] matches in
                self?.view?.showLoading(false)
                self?.matches = matches
                self?.restoreSelectedOdds()
                self?.view?.showMatches()
            }, onFailure: { [weak self] error in
                self?.view?.showLoading(false)
                self?.view?.showError(error.localizedDescription)
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
}
