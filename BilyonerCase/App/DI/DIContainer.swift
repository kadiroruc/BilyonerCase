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
    private var singletons: [String: Any] = [:]
    private var singletonKeys: Set<String> = []
    
    private init() {}

    func register<T>(_ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        factories[key] = factory
    }
    
    func registerSingleton<T>(_ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        factories[key] = factory
        singletonKeys.insert(key)
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)
        
        // Check if it's a singleton first
        if singletonKeys.contains(key), let singleton = singletons[key] as? T {
            return singleton
        }
        
        guard let factory = factories[key], let instance = factory() as? T else {
            fatalError("There is no registered factory for '\(key)'")
        }
        
        // If it was registered as singleton, store it
        if singletonKeys.contains(key) {
            singletons[key] = instance
        }
        
        return instance
    }
}
