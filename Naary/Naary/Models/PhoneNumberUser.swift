//
//  PhoneNumberUser.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import FirebaseAuth

struct PhoneNumberUser: User, Codable {
    var phoneNumber: String
    
    var email: String
    
    var displayName: String
    
    init(from user: AuthDataResult) {
        self.phoneNumber = user.user.phoneNumber ?? ""
        self.email = user.user.email ?? ""
        self.displayName = user.user.displayName ?? ""
    }
    
    init(phoneNumber: String, email: String, displayName: String) {
        self.phoneNumber = phoneNumber
        self.email = email
        self.displayName = displayName
    }
}

