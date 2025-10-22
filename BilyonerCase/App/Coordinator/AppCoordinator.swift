//
//  AppCoordinator.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let factory: AppFactory
    private let userManager = UserManager.shared

    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
        self.factory = AppFactory()
    }

    func start() {
        if userManager.isUserAvailable {
            showMainFlow()
        } else {
            showAuthFlow()
        }
        window.makeKeyAndVisible()
    }

    private func showAuthFlow() {
        let loginVC = factory.makeLoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        navigationController = nav
        window.rootViewController = nav
    }

    private func showMainFlow() {
        let tabBarController = MainTabBarController(factory: factory)
        window.rootViewController = tabBarController
    }
}

