//
//  UserDefaultsProtocol.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

protocol UserDefaultsProtocol: AnyObject {
    func getLoggedInPhoneUserInfo() -> PhoneNumberUser?
    func saveLoggedInPhoneUserInfo(user: AuthDataResult)
    func saveLoggedInPhoneUserInfo(user: PhoneNumberUser)
    func deleteLoggedInPhoneUserInfo()
    
    func getLoggedInGoogleUserInfo() -> GoogleUser?
    func saveLoggedInGoogleUserInfo(user: GIDGoogleUser)
    func deleteLoggedInGoogleUserInfo()
    
    func saveString(value: String, forKey: String)
    func saveBool(value: Bool, forKey: String)
}

