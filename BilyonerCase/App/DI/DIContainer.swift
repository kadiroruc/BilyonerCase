//
//  DIContainer.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var factories: [String: () -> Any] = [:]
    
    private init() {}

    func register<T>(_ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        factories[key] = factory
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let factory = factories[key], let instance = factory() as? T else {
            fatalError("There is no registered factory for '\(key)'")
        }
        return instance
    }
}
