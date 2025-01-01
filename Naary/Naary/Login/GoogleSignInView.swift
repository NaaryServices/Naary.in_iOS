//
//  GoogleSignInView.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI
import GoogleSignIn
import Swinject

struct GoogleSignInView: View {
    @State private var showHomeView = false
    @State private var errorMessage: String = ""
    @StateObject private var viewModel: LoginViewModel
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        _viewModel = StateObject(wrappedValue: resolver.resolve(LoginViewModel.self)!)
    }
    
    var body: some View {
        Button(action: signInWithGoogle) {
            Text("Sign in with Google")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
        }
        .padding()
        .fullScreenCover(isPresented: $showHomeView) {
            if let user = viewModel.getUserInfoLocal() {
                HomeView(resolver: resolver)
            }// Navigate to the Home View on success
        }
        if !errorMessage.isEmpty {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
    }
    
    private func signInWithGoogle() {
        viewModel.signInWithGoogle { result in
            switch result {
            case .success(let success):
                showHomeView = true
            case .failure(let failure):
                showHomeView = false
            }
        }
    }
}
