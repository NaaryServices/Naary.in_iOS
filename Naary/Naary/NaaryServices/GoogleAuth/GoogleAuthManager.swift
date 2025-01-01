//
//  GoogleAuthManager.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import GoogleSignIn

class GoogleAuthManager: GoogleAuthProtocol {
    
    let userDefaultsProtocol: UserDefaultsProtocol
    init(userDefaultsProtocol: UserDefaultsProtocol) {
        self.userDefaultsProtocol = userDefaultsProtocol
    }
    
    func signInWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.windows.first!.rootViewController!) { [weak self] result, error in
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let user = result?.user {
                self?.userDefaultsProtocol.saveLoggedInGoogleUserInfo(user: user)
                self?.userDefaultsProtocol.saveBool(value: true, forKey: "isGoogleUser")
                completion(.success(true))
            }
        }
    }
    
    func signOutWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void) {
        GIDSignIn.sharedInstance.signOut()
        self.userDefaultsProtocol.deleteLoggedInGoogleUserInfo()
        self.userDefaultsProtocol.saveBool(value: false, forKey: "isGoogleUser")
        completion(.success(true))
    }
    
    func isGoogleLoggedInUser() -> Bool {
        if let user = userDefaultsProtocol.getLoggedInGoogleUserInfo(), !user.email.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getLoggedInGoogleUser() -> User? {
        return userDefaultsProtocol.getLoggedInGoogleUserInfo()
    }
}
