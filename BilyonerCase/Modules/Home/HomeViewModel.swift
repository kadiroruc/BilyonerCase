//
//  HomeViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation
import RxSwift

protocol HomeViewModelProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var leagues: [League] { get }
    var matches: [Match] { get }
    
    func fetchLeagues()
    func fetchMatches(leagueKey: String)
}

final class HomeViewModel: HomeViewModelProtocol {

    weak var view: HomeViewProtocol?
    private let apiClient: APIClientProtocol
    private let disposeBag = DisposeBag()

    var leagues: [League] = []
    var matches: [Match] = []

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
                self?.view?.showMatches()
            }, onFailure: { [weak self] error in
                self?.view?.showLoading(false)
                self?.view?.showError(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
