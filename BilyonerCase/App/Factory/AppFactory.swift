//
//  AppFactory.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

final class AppFactory {
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - Auth
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(
            authService: container.resolve()
        )
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(
            authService: container.resolve()
        )
    }
    
    func makeLoginViewController() -> LoginViewController {
        container.resolve()
    }

    func makeSignUpViewController() -> SignUpViewController {
        container.resolve()
    }

}

