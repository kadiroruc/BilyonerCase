//
//  SignUpViewModel.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 17.10.2025.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol SignUpViewModelDelegate: AnyObject {
    var view: SignUpViewDelegate? { get set }
    func signUp(name: String, email: String, password: String)
}

// MARK: - SignUpViewModel

final class SignUpViewModel {

    weak var view: SignUpViewDelegate?
    private let authService: AuthServiceDelegate
    private let disposeBag = DisposeBag()

    init(authService: AuthServiceDelegate) {
        self.authService = authService
    }
}

// MARK: - SignUpViewModelDelegate

extension SignUpViewModel: SignUpViewModelDelegate {

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

