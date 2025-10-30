//
//  APIClient.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 20.10.2025.
//

import Foundation
import Alamofire
import RxSwift

protocol APIClientDelegate {
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> Single<T>
}

// MARK: - APIClient

final class APIClient {

}

extension APIClient: APIClientDelegate {
    
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> Single<T> {
        return Single.create { single in
            let url = endpoint.baseURL + endpoint.path
            let method = endpoint.method
            let parameters = endpoint.parameters

            AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }
}



