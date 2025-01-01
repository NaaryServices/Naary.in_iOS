//
//  PhoneAuthProtocol.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation

protocol PhoneAuthProtocol: AnyObject {
    func sendOTP(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func verifyOTP(otp: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func logoutPhoneNumberUser(completion: @escaping (Result<Bool, Error>) -> Void)
    func isPhoneNumberLoggedInUser() -> Bool
    func getLoggedInPhoneUser() -> User?
    func save(user: PhoneNumberUser)
    func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void)
    func saveUserIfFirstTime(user: PhoneNumberUser, completion: @escaping (Bool, Error?) -> Void)
    func getUserDetails(completion: @escaping (PhoneNumberUser?, Error?) -> Void)
}

