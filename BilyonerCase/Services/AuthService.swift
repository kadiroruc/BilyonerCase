//
//  AuthService.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 16.10.2025.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> Single<User>
    func register(email: String, password: String) -> Single<User>
}

final class AuthService: AuthServiceProtocol {
    func login(email: String, password: String) -> Single<User> {
        return Single.create { single in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    single(.failure(error))
                } else if let user = result?.user {
                    single(.success(user))
                } else {
                    single(.failure(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            }
            return Disposables.create()
        }
    }
    
    func register(email: String, password: String) -> Single<User> {
        return Single.create { single in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let user = result?.user else {
                    single(.failure(NSError(domain: "RegisterError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }
                single(.success(user))
            }
            return Disposables.create()
        }
    }
}



