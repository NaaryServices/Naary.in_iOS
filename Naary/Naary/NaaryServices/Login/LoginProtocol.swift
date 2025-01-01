//
//  LoginProtocol.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import GoogleSignIn

protocol LoginProtocol {
    func signInWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void)
    func handleLoginWithPhoneNumber(with phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func verifyOTP(otp: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func logout(completion: @escaping (Result<Bool, Error>) -> Void)
    func getUserInfo() -> User?
    func save(user: PhoneNumberUser)
    func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void)
    func saveUserIfFirstTime(user: PhoneNumberUser, completion: @escaping (Bool, Error?) -> Void)
    func getUserDetails(completion: @escaping (PhoneNumberUser?, Error?) -> Void)
}
