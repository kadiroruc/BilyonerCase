//
//  AppCoordinator.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import UIKit
import FirebaseAuth

final class AppCoordinator {
    private let window: UIWindow
    private let container: DIContainer
    private let factory: AppFactory

    private var navigationController: UINavigationController?

    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
        self.factory = AppFactory(container: container)
    }

    func start() {
//        if Auth.auth().currentUser != nil {
//            showMainFlow()
//        } else {
//            showAuthFlow()
//        }
        showAuthFlow()
        window.makeKeyAndVisible()
    }

    private func showAuthFlow() {
        let loginVC = factory.makeLoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        navigationController = nav
        window.rootViewController = nav
    }

    private func showMainFlow() {
    }
}

