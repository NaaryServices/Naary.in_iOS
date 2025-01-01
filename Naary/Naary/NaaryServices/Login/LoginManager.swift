//
//  LoginManager.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import FirebaseAuth

class LoginManager: LoginProtocol {
    
    let phoneAuthProtocol: PhoneAuthProtocol
    let googleAuthProtocol: GoogleAuthProtocol
    
    init(phoneAuthProtocol: PhoneAuthProtocol, googleAuthProtocol: GoogleAuthProtocol) {
        self.phoneAuthProtocol = phoneAuthProtocol
        self.googleAuthProtocol = googleAuthProtocol
    }
    
    func signInWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void) {
        googleAuthProtocol.signInWithGoogle(completion: completion)
    }
    
    func handleLoginWithPhoneNumber(with phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        phoneAuthProtocol.sendOTP(phoneNumber: phoneNumber, completion: completion)
    }
    
    func verifyOTP(otp: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        phoneAuthProtocol.verifyOTP(otp: otp, completion: completion)
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        if phoneAuthProtocol.isPhoneNumberLoggedInUser() {
            logoutPhoneNumber(completion: completion)
        } else if googleAuthProtocol.isGoogleLoggedInUser() {
            signOutWithGoogle(completion: completion)
        }
    }
    
    func getUserInfo() -> User? {
        if phoneAuthProtocol.isPhoneNumberLoggedInUser() {
            return phoneAuthProtocol.getLoggedInPhoneUser()
        }
        if googleAuthProtocol.isGoogleLoggedInUser() {
            return googleAuthProtocol.getLoggedInGoogleUser()
        }
        return nil
    }
    
    func save(user: PhoneNumberUser) {
        phoneAuthProtocol.save(user: user)
    }
    
    func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool, (any Error)?) -> Void) {
        phoneAuthProtocol.checkIfUserExists(phoneNumber: phoneNumber, completion: completion)
    }
    
    func saveUserIfFirstTime(user: PhoneNumberUser, completion: @escaping (Bool, (any Error)?) -> Void) {
        phoneAuthProtocol.saveUserIfFirstTime(user: user, completion: completion)
    }
    
    func getUserDetails(completion: @escaping (PhoneNumberUser?, Error?) -> Void) {
        phoneAuthProtocol.getUserDetails(completion: completion)
    }
    
    private func signOutWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void) {
        googleAuthProtocol.signOutWithGoogle(completion: completion)
    }
    
    private func logoutPhoneNumber(completion: @escaping (Result<Bool, Error>) -> Void) {
        phoneAuthProtocol.logoutPhoneNumberUser(completion: completion)
    }
    
}
