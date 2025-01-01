//
//  LoginSelectionView.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI
import Swinject

struct LoginSelectionView: View {
    
    @StateObject private var viewModel: LoginViewModel
    @State private var showHomeView = false
    
    let resolver: Resolver
    init(resolver: Resolver) {
        let viewModel = resolver.resolve(LoginViewModel.self)!
        _viewModel = StateObject(wrappedValue: viewModel)
        self.resolver = resolver
    }
    
    var body: some View {
        Group {
            
            if let user = viewModel.getUserInfoLocal() {
                HomeView(resolver: resolver)
            } else {
                // Show login methods if not logged in
                getLoginSelectionView()
            }
        }
    }
    
    @ViewBuilder
    func getLoginSelectionView() -> some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Custom Header View
                LoginHeader(text: "Login", backHidden: true)
                
                Spacer()
                
                // Welcome Text
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Spacer()
                Spacer()
                // Instruction Text
                Text("Please select a login method:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                // Login Buttons
                VStack(spacing: 15) {
                    // Login with Phone Number
                    NavigationLink(
                        destination: LoginPhoneNumberView(resolver: resolver),
                        label: {
                            Text("Login with Phone Number")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        })
                    
                    // Login with Google
                    Button(action: {
                        viewModel.signInWithGoogle { result in
                            switch result {
                            case .success(let success):
                                showHomeView = true
                            case .failure(let failure):
                                print("Login error")
                            }
                        }
                    }) {
                        Text("Login with Google")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    .fullScreenCover(isPresented: $showHomeView) {
                        HomeView(resolver: resolver)
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}
