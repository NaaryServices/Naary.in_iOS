//
//  User.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Foundation

protocol User: Codable {
    var phoneNumber: String { get }
    var email: String { get }
    var displayName: String { get }
}
