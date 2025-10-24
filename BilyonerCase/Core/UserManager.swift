//
//  UserManager.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 22.10.2025.
//

import Foundation
import FirebaseAuth

protocol UserManagerDelegate: AnyObject {
    var isUserAvailable: Bool { get }
    var currentUser: User? { get }
    func refresh()
    func logout()
}

final class UserManager: UserManagerDelegate {
    static let shared = UserManager()

    static let userStateDidChangeNotification = Notification.Name("UserManager.userStateDidChange")

    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    private var cachedIsUserAvailable: Bool = false

    private init() {
        cachedIsUserAvailable = Auth.auth().currentUser != nil
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            let newValue = (user != nil)
            if newValue != self.cachedIsUserAvailable {
                self.cachedIsUserAvailable = newValue
                NotificationCenter.default.post(name: UserManager.userStateDidChangeNotification, object: nil)
            }
        }
    }

    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    var isUserAvailable: Bool { cachedIsUserAvailable }

    var currentUser: User? { Auth.auth().currentUser }

    func refresh() {
        let newValue = Auth.auth().currentUser != nil
        if newValue != cachedIsUserAvailable {
            cachedIsUserAvailable = newValue
            NotificationCenter.default.post(name: UserManager.userStateDidChangeNotification, object: nil)
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            refresh()
        } catch {
            print("Logout error: \(error.localizedDescription)")
            
            refresh()
        }
    }
}


