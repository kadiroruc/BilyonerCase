//
//  MainTabBarController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 21.10.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let factory: AppFactory

    init(factory: AppFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabBar() {
        let bulletinVC = UINavigationController(rootViewController: factory.makeBulletinViewController())
        bulletinVC.tabBarItem = UITabBarItem(title: "Bulletin", image: UIImage(systemName: "house"), tag: 0)
        
        let basketVC = UINavigationController(rootViewController: factory.makeBasketViewController())
        basketVC.tabBarItem = UITabBarItem(title: "Basket", image: UIImage(systemName: "cart"), tag: 1)
        basketVC.tabBarItem.badgeColor = .systemGreen

        viewControllers = [bulletinVC, basketVC]

        tabBar.tintColor = .systemGreen
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
        
    }
}
