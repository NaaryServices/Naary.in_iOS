import Foundation

protocol GoogleAuthProtocol: AnyObject {
    func signInWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void)
    func signOutWithGoogle(completion: @escaping (Result<Bool, Error>) -> Void)
    func isGoogleLoggedInUser() -> Bool
    func getLoggedInGoogleUser() -> User?
}
