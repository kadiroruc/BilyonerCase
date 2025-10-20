//
//  AppDIContainer.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation

final class AppDIContainer {
    static let shared = AppDIContainer()
    let container = DIContainer.shared

    private init() {}

    func configure() {
        registerServices()
        registerViewModels()
        registerViewControllers()
    }

    private func registerServices() {
        container.register { AuthService() as AuthServiceProtocol }
    }

    private func registerViewModels() {
        container.register {
            LoginViewModel(authService: self.container.resolve()) as LoginViewModelProtocol
        }

        container.register {
            SignUpViewModel(authService: self.container.resolve()) as SignUpViewModelProtocol
        }
    }
    
    private func registerViewControllers() {
        container.register {
            LoginViewController(viewModel: self.container.resolve())
        }

        container.register {
            SignUpViewController(viewModel: self.container.resolve())
        }
    }
}

