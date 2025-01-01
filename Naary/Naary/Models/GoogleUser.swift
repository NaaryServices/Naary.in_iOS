//
//  GoogleUser.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation
import GoogleSignIn

struct GoogleUser: User, Codable {
    var phoneNumber: String
    
    let userID: String
    let email: String
    let fullName: String
    let givenName: String
    let familyName: String
    let profileImageURL: String?
    let idToken: String?
    
    var displayName: String
    
    init(from user: GIDGoogleUser) {
        self.userID = user.userID ?? ""
        self.email = user.profile?.email ?? ""
        self.fullName = user.profile?.name ?? ""
        self.givenName = user.profile?.givenName ?? ""
        self.familyName = user.profile?.familyName ?? ""
        self.profileImageURL = user.profile?.imageURL(withDimension: 100)?.absoluteString
        self.idToken = user.idToken?.tokenString
        
        self.displayName = self.fullName
        self.phoneNumber = ""
    }
}


