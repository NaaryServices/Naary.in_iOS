import Foundation

class HomeViewModel: ObservableObject {
    
    private let loginProtocol: LoginProtocol!
    init(loginProtocol: LoginProtocol) {
        self.loginProtocol = loginProtocol
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        loginProtocol.logout(completion: completion)
    }
    
    func getUserInfoLocal() -> User? {
        if let user = loginProtocol.getUserInfo() {
            return user
        }
        return nil
    }
    
    func getUserDetails(completion: @escaping (PhoneNumberUser?, Error?) -> Void) {
        loginProtocol.getUserDetails(completion: completion)
    }
}
