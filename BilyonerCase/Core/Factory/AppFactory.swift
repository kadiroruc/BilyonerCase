//
//  AppFactory.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

final class AppFactory {
    private let container = DIContainer.shared
    
    init() {
        registerDependencies()
    }

    // MARK: - Dependency Registration
    private func registerDependencies() {
        // Services
        container.register { AuthService() as AuthServiceDelegate }
        container.register { APIClient() as APIClientDelegate }

        // ViewModels
        container.register {
            LoginViewModel(authService: self.container.resolve()) as LoginViewModelDelegate
        }
        container.register {
            SignUpViewModel(authService: self.container.resolve()) as SignUpViewModelDelegate
        }
        container.registerSingleton {
            BulletinViewModel(apiClient: self.container.resolve()) as BulletinViewModelDelegate
        }
        container.register {
            BasketViewModel() as BasketViewModelDelegate
        }

        // ViewControllers
        container.register {
            LoginViewController(viewModel: self.container.resolve())
        }
        container.register {
            SignUpViewController(viewModel: self.container.resolve())
        }
        container.register {
            BulletinViewController(viewModel: self.container.resolve())
        }
        container.register {
            BasketViewController(viewModel: self.container.resolve(), bulletinVM: self.container.resolve())
        }
    }

    // MARK: - Factory Methods (optional convenience)

    func makeLoginViewController() -> LoginViewController {
        container.resolve()
    }

    func makeSignUpViewController() -> SignUpViewController {
        container.resolve()
    }

    func makeBulletinViewController() -> BulletinViewController {
        container.resolve()
    }
    
    func makeBasketViewController() -> BasketViewController {
        container.resolve()
    }
}
