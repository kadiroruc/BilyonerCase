//
//  LoginViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 16.10.2025.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol LoginViewModelProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    func login(email: String, password: String)
}

final class LoginViewModel {

    weak var view: LoginViewProtocol?
    private let authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}

// MARK: - LoginViewModelProtocol
extension LoginViewModel: LoginViewModelProtocol {

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
            .subscribe(onSuccess: { [weak self] user in
                DispatchQueue.main.async {
                    self?.view?.showLoading(false)
                    self?.view?.showSuccess(user)
                }
            }, onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.view?.showLoading(false)
                    self?.view?.showError(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
