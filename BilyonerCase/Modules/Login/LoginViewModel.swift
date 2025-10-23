//
//  LoginViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 16.10.2025.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol LoginViewModelDelegate: AnyObject {
    var view: LoginViewDelegate? { get set }
    func login(email: String, password: String)
}

final class LoginViewModel {

    weak var view: LoginViewDelegate?
    private let authService: AuthServiceDelegate
    private let disposeBag = DisposeBag()

    init(authService: AuthServiceDelegate) {
        self.authService = authService
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewModel: LoginViewModelDelegate {

    func login(email: String, password: String) {
        guard email.isValidEmail else {
            view?.showError("Please enter a valid email address.")
            return
        }

        guard password.count >= 6 else {
            view?.showError("Password must be at least 6 characters.")
            return
        }

        view?.showLoading(true)

        authService.login(email: email, password: password)
            .subscribe(with: self,
                       onSuccess: { owner, user in
                           DispatchQueue.main.async {
                               owner.view?.showLoading(false)
                               owner.view?.showSuccess(user)
                           }
                       },
                       onFailure: { owner, error in
                           DispatchQueue.main.async {
                               owner.view?.showLoading(false)
                               owner.view?.showError(error.localizedDescription)
                           }
                       })
            .disposed(by: disposeBag)

    }
}
