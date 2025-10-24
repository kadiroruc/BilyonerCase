//
//  BasketViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//

import Foundation
import RxSwift

protocol BasketViewModelDelegate: AnyObject {
    var view: BasketViewDelegate? { get set }
    
    var bets: [MatchBet] { get }
    var couponAmount: Double { get }
    var totalOdds: Double { get }
    var maxWin: Double { get }
    var balance: Double { get }
    
    func bind(to bulletinVM: BulletinViewModelDelegate)
    func updateCouponAmount(_ amount: Double)
    func clearAllBets()
    func playNow()
}

final class BasketViewModel: BasketViewModelDelegate {
    weak var view: BasketViewDelegate?
    
    private let disposeBag = DisposeBag()
    private(set) var bets: [MatchBet] = []
    private(set) var couponAmount: Double = 50.0
    private(set) var balance: Double = 1000.0
    private weak var bulletinVM: BulletinViewModelDelegate?

    func bind(to bulletinVM: BulletinViewModelDelegate) {
        self.bulletinVM = bulletinVM
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
        view?.updateBadgeValue(bets.count)
        view?.updateCouponDetails()
    }
    
    var totalOdds: Double {
        return bets.compactMap { Double($0.value) }.reduce(1.0, *)
    }
    
    var maxWin: Double {
        return couponAmount * totalOdds
    }
    
    func updateCouponAmount(_ amount: Double) {
        couponAmount = max(50.0, amount)
        
        if amount < 50.0 || balance < amount {
            view?.enablePlayNowButton(isEnabled: false)
        }else{
            view?.enablePlayNowButton(isEnabled: true)
        }
    }
    
    func clearAllBets() {
        bets.removeAll()
        bulletinVM?.clearAllSelectedOdds()
        view?.showBets()
        view?.updateBadgeValue(bets.count)
        view?.updateCouponDetails()
    }
    
    func playNow() {
        guard !bets.isEmpty else {
            view?.showError("Please select at least one match")
            return
        }
        
        balance -= couponAmount
        clearAllBets()
        
        view?.showSuccess("Your bet has been placed successfully")
    }
}
