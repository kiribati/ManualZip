//
//  AuthService.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Foundation
import FirebaseAuth
import Combine

final class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    func signInAnonymous() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            if let currentUser = Auth.auth().currentUser {
                promise(.success(currentUser))
            } else {
                Auth.auth().signInAnonymously { authResult, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let user = authResult?.user {
                        promise(.success(user))
                    } else {
                        promise(.failure(NSError(domain: "AUthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
