//
//  AppFactory.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

final class AppFactory {
    static let shared = AppFactory()
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
        container.register {
            HomeViewModel(apiClient: self.container.resolve()) as HomeViewModelDelegate
        }

        // ViewControllers
        container.register {
            LoginViewController(viewModel: self.container.resolve())
        }
        container.register {
            SignUpViewController(viewModel: self.container.resolve())
        }
        container.register {
            HomeViewController(viewModel: self.container.resolve())
        }
    }

    // MARK: - Factory Methods (optional convenience)

    func makeLoginViewController() -> LoginViewController {
        container.resolve()
    }

    func makeSignUpViewController() -> SignUpViewController {
        container.resolve()
    }

    func makeHomeViewController() -> HomeViewController {
        container.resolve()
    }
}
