//
//  AppAssembly.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import Swinject
import SwinjectStoryboard

class AppAssembly: Assembly {
    func assemble(container: Container) {
        // Register services
        container.register(UserDefaultsProtocol.self) { _ in
            UserDefaultsManager()
        }
        
        container.register(PhoneAuthProtocol.self) { resolver in
            let userDefaultsManager = resolver.resolve(UserDefaultsProtocol.self)!
            return PhoneAuthManager(userDefaultsProtocol: userDefaultsManager)
        }
        
        container.register(GoogleAuthProtocol.self) { resolver in
            let userDefaultsManager = resolver.resolve(UserDefaultsProtocol.self)!
            return GoogleAuthManager(userDefaultsProtocol: userDefaultsManager)
        }
        
        container.register(LoginProtocol.self) { resolver in
            let phoneAuthManager = resolver.resolve(PhoneAuthProtocol.self)!
            let googleAuthManager = resolver.resolve(GoogleAuthProtocol.self)!
            return LoginManager(phoneAuthProtocol: phoneAuthManager, googleAuthProtocol: googleAuthManager)
        }
        
        // Register ViewModels
        container.register(LoginViewModel.self) { resolver in
            let loginManager = resolver.resolve(LoginProtocol.self)!
            return LoginViewModel(loginProtocol: loginManager)
        }
        
        container.register(HomeViewModel.self) { resolver in
            let loginManager = resolver.resolve(LoginProtocol.self)!
            return HomeViewModel(loginProtocol: loginManager)
        }
    }
}
