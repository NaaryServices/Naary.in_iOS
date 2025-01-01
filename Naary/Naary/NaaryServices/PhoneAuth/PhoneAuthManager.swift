//
//  PhoneAuthManager.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import FirebaseAuth
import FirebaseFirestore

class PhoneAuthManager: PhoneAuthProtocol {
    
    let userDefaultsProtocol: UserDefaultsProtocol
    init(userDefaultsProtocol: UserDefaultsProtocol) {
        self.userDefaultsProtocol = userDefaultsProtocol
    }
    
    func sendOTP(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+91\(phoneNumber)", uiDelegate: nil) {[weak self] verificationID, error in
            if let error = error {
                completion(.failure(error))
            } else if let verificationID = verificationID {
                self?.userDefaultsProtocol.saveString(value: verificationID, forKey: "authVerificationID")
                completion(.success(true))
            }
        }
    }
    
    func verifyOTP(otp: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(.failure(NSError(domain: "PhoneAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing verification ID"])))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
        Auth.auth().signIn(with: credential) { [weak self] user, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let user = user {
                    self?.userDefaultsProtocol.saveBool(value: true, forKey: "isPhoneNumberUser")
                    self?.userDefaultsProtocol.saveLoggedInPhoneUserInfo(user: user)
                    completion(.success(true))
                }
            }
        }
    }
    
    func logoutPhoneNumberUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.userDefaultsProtocol.deleteLoggedInPhoneUserInfo()
            self.userDefaultsProtocol.saveBool(value: false, forKey: "isPhoneNumberUser")
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func isPhoneNumberLoggedInUser() -> Bool {
        if let user = self.userDefaultsProtocol.getLoggedInPhoneUserInfo(), !user.phoneNumber.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getLoggedInPhoneUser() -> User? {
        return self.userDefaultsProtocol.getLoggedInPhoneUserInfo()
    }
    
    func save(user: PhoneNumberUser) {
        self.userDefaultsProtocol.saveLoggedInPhoneUserInfo(user: user)
    }
    
    func saveUserIfFirstTime(user: PhoneNumberUser, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("phoneUsers")
        var ph = "+91"
        ph.append(user.phoneNumber)
        usersCollection.document(ph).getDocument { (document, error) in
            if let error = error {
                completion(false, error)
                return
            }
            
            if let document = document, document.exists {
                // User already exists
                completion(false, nil)
            } else {
                // First-time login, save user data
                
                self.userDefaultsProtocol.saveLoggedInPhoneUserInfo(user: user)
                usersCollection.document(ph).setData([
                    "phoneNumber": ph,
                    "isFirstLogin": true,
                    "createdAt": FieldValue.serverTimestamp(),
                    "email": user.email,
                    "displayName": user.displayName
                ]) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("phoneUsers")
        var ph = "+91"
        ph.append(phoneNumber)
        usersCollection.document(ph).getDocument { (document, error) in
            if let error = error {
                completion(false, error)
                return
            }
            
            if let document = document, document.exists {
                // User exists
                self.getUserDetails { user, error in
                    if error == nil, let user = user {
                        self.userDefaultsProtocol.saveLoggedInPhoneUserInfo(user: user)
                    }
                }
                completion(true, nil)
            } else {
                // User does not exist
                completion(false, nil)
            }
        }
    }
    
    func getUserDetails(completion: @escaping (PhoneNumberUser?, Error?) -> Void) {
        let db = Firestore.firestore()
        let collectionName = "phoneUsers"
        var phoneUser: PhoneNumberUser? = nil
        guard let user = Auth.auth().currentUser, let documentID = user.phoneNumber else { return }
        db.collection(collectionName).document(documentID).getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                do {
                    phoneUser = try document.data(as: PhoneNumberUser.self)
                    if let phoneUser = phoneUser {
                        self.save(user: phoneUser)
                    }
                    completion(phoneUser, nil)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    completion(nil, error)
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
}
