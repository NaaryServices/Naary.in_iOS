//
//  LoginViewModel.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

class LoginViewModel: ObservableObject {
    
    private let loginProtocol: LoginProtocol!
    
    init(loginProtocol: LoginProtocol) {
        self.loginProtocol = loginProtocol
    }
    
    
    func signInWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void) {
        loginProtocol.signInWithGoogle(completion: completion)
    }
    
    func handleLoginUsingPhoneNumber(with phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Send OTP using Firebase
        loginProtocol.handleLoginWithPhoneNumber(with: phoneNumber, completion: completion)
    }
    
    func verifyOTP(with otp: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        loginProtocol.verifyOTP(otp: otp, completion: completion)
    }
    
    func getUserInfoLocal() -> User? {
        if let user = loginProtocol.getUserInfo() {
            return user
        }
        return nil
    }
    
    func save(user: PhoneNumberUser) {
        loginProtocol.save(user: user)
    }
    
    func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        loginProtocol.checkIfUserExists(phoneNumber: phoneNumber, completion: completion)
    }
    
    func saveUserIfFirstTime(user: PhoneNumberUser, completion: @escaping (Bool, Error?) -> Void) {
        loginProtocol.saveUserIfFirstTime(user: user, completion: completion)
    }
    
}
