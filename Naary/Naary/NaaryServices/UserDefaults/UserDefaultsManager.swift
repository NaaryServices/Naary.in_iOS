//
//  UserDefaultsManager.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class UserDefaultsManager: UserDefaultsProtocol {
    
    let userDefaults = UserDefaults.standard
    
    func getLoggedInPhoneUserInfo() -> PhoneNumberUser? {
        do {
            if let user = userDefaults.data(forKey: "LoggedInPhoneNumberUser") {
                let userData = try JSONDecoder().decode(PhoneNumberUser.self, from: user)
                return userData
            }
        } catch {
            print("Error decoding Google user: \(error)")
        }
        return nil
    }
    
    func saveLoggedInPhoneUserInfo(user: AuthDataResult) {
        let phoneUser = PhoneNumberUser(from: user)
        do {
            let userData = try JSONEncoder().encode(phoneUser)
            userDefaults.set(userData, forKey: "LoggedInPhoneNumberUser")
        } catch {
            print("Error encoding Google user: \(error)")
        }
    }
    
    func saveLoggedInPhoneUserInfo(user: PhoneNumberUser) {
        do {
            let userData = try JSONEncoder().encode(user)
            userDefaults.set(userData, forKey: "LoggedInPhoneNumberUser")
        } catch {
            print("Error encoding Google user: \(error)")
        }
    }
    
    func deleteLoggedInPhoneUserInfo() {
        userDefaults.removeObject(forKey: "LoggedInPhoneNumberUser")
    }
    
    func getLoggedInGoogleUserInfo() -> GoogleUser? {
        do {
            if let user = userDefaults.data(forKey: "googleUser") {
                let userData = try JSONDecoder().decode(GoogleUser.self, from: user)
                return userData
            }
        } catch {
            print("Error decoding Google user: \(error)")
        }
        return nil
    }
    
    func saveLoggedInGoogleUserInfo(user: GIDGoogleUser) {
        let googleUser = GoogleUser(from: user)
        do {
            let userData = try JSONEncoder().encode(googleUser)
            userDefaults.set(userData, forKey: "googleUser")
        } catch {
            print("Error encoding Google user: \(error)")
        }
    }
    
    func deleteLoggedInGoogleUserInfo() {
        userDefaults.removeObject(forKey: "googleUser")
    }
    
    func saveString(value: String, forKey: String) {
        userDefaults.set(value, forKey: forKey)
    }
    
    func saveBool(value: Bool, forKey: String) {
        userDefaults.set(value, forKey: forKey)
    }
}
