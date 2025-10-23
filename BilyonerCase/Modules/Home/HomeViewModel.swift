//
//  HomeViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation
import RxSwift

protocol HomeViewModelDelegate: AnyObject {
    var view: HomeViewDelegate? { get set }
    var leagues: [League] { get }
    var matches: [Match] { get }
    
    func fetchLeagues()
    func fetchMatches(leagueKey: String)
}

final class HomeViewModel: HomeViewModelDelegate {

    weak var view: HomeViewDelegate?
    private let apiClient: APIClientDelegate
    private let disposeBag = DisposeBag()

    var leagues: [League] = []
    var matches: [Match] = []

    init(apiClient: APIClientDelegate) {
        self.apiClient = apiClient
    }

    func fetchLeagues() {
        view?.showLoading(true)
        apiClient.request(OddsAPI.getLeagues, type: [League].self)
            .subscribe(
                with: self,
                onSuccess: { owner, leagues in
                    owner.view?.showLoading(false)
                    owner.leagues = leagues.filter { !$0.has_outrights }
                    owner.view?.showLeagues(owner.leagues)
                },
                onFailure: { owner, error in
                    owner.view?.showLoading(false)
                    owner.view?.showError(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)

    }

    func fetchMatches(leagueKey: String) {
        view?.showLoading(true)
        apiClient.request(OddsAPI.getMatches(leagueKey: leagueKey), type: [Match].self)
            .subscribe(with: self,
                       onSuccess: { owner, matches in
                           owner.view?.showLoading(false)
                           owner.matches = matches
                           owner.view?.showMatches()
                       },
                       onFailure: { owner, error in
                           owner.view?.showLoading(false)
                           owner.view?.showError(error.localizedDescription)
                       })
            .disposed(by: disposeBag)

    }
}
