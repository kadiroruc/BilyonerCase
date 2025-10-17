//
//  SignUpViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 17.10.2025.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol SignUpViewModelProtocol: AnyObject {
    var view: SignUpViewProtocol? { get set }
    func signUp(name: String, email: String, password: String)
}

final class SignUpViewModel {

    weak var view: SignUpViewProtocol?
    private let authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}

// MARK: - SignUpViewModelProtocol
extension SignUpViewModel: SignUpViewModelProtocol {

    func signUp(name: String, email: String, password: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            view?.showError("Name cannot be empty.")
            return
        }

        guard email.isValidEmail else {
            view?.showError("Please enter a valid email address.")
            return
        }

        guard password.count >= 6 else {
            view?.showError("Password must be at least 6 characters.")
            return
        }

        view?.showLoading(true)

        authService.register(email: email, password: password)
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

