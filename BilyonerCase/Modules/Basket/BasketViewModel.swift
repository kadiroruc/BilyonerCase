//
//  BasketViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//

import Foundation
import RxSwift

protocol BasketViewModelProtocol: AnyObject {
    var view: BasketViewProtocol? { get set }
    
    var bets: [MatchBet] { get }
    func bind(to bulletinVM: BulletinViewModelProtocol)

}

final class BasketViewModel: BasketViewModelProtocol {
    weak var view: BasketViewProtocol?
    
    private let disposeBag = DisposeBag()
    private(set) var bets: [MatchBet] = []

    func bind(to bulletinVM: BulletinViewModelProtocol) {
        bulletinVM.betSelected
            .subscribe(onNext: { [weak self] bet in
                self?.addOrUpdateBet(bet)
            })
            .disposed(by: disposeBag)
    }

    private func addOrUpdateBet(_ bet: MatchBet) {
        if let index = bets.firstIndex(where: { $0.match.id == bet.match.id }) {
            if bet.match.selectedOdd != nil {
                bets[index] = bet
            }else{
                bets.remove(at: index)
            }  
        } else {
            bets.append(bet)
        }
        view?.showBets()
    }
}







