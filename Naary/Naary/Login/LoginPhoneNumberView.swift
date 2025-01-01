//
//  LoginPhoneNumberView.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI
import FirebaseAuth
import Swinject

struct LoginPhoneNumberView: View {
    @State private var phoneNumber: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @FocusState private var isFocused: Bool
    @State private var isOTPViewPresented = false // State to show OTP view
    @State private var verificationID: String?
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    
    // State for navigation
    @State private var navigateToOTP = false
    
    @StateObject private var viewModel: LoginViewModel
    let resolver: Resolver
    init(resolver: Resolver) {
        let viewModel = resolver.resolve(LoginViewModel.self)!
        _viewModel = StateObject(wrappedValue: viewModel)
        self.resolver = resolver
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    // Phone Number Input
                    TextField("Enter your phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .multilineTextAlignment(.center)
                        .focused($isFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(phoneNumber.isEmpty || phoneNumber.count >= 10 ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .modifier(ClearButtonModifier(text: $phoneNumber))
                    
                    // Login Button
                    Button(action: {
                        handleLogin()
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(isLoading)
                    
                    Spacer()
                }
                .padding()
                .blur(radius: isLoading ? 3 : 0)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .onTapGesture {
                    isFocused = false // Dismiss keyboard on tap outside
                }
                .navigationTitle("Login with Phone Number") // Set navigation title
                .navigationBarBackButtonHidden(true)
                if isLoading {
                    ZStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                // Navigate to OTP View when the button is pressed
                NavigationLink(destination: OTPView(resolver: resolver, phoneNumber: phoneNumber), isActive: $navigateToOTP) {
                    EmptyView() // NavigationLink is triggered programmatically
                }
            }
        }
    }
    
    // Login Button Action
    func handleLogin() {
        // Validate phone number
        guard !phoneNumber.isEmpty else {
            alertMessage = "Please enter a phone number"
            showAlert = true
            return
        }
        
        guard phoneNumber.count >= 10, phoneNumber.allSatisfy({ $0.isNumber }) else {
            alertMessage = "Please enter a valid phone number"
            showAlert = true
            return
        }
        
        isLoading = true
        isFocused = false // Dismiss keyboard
        viewModel.handleLoginUsingPhoneNumber(with: phoneNumber) { result in
            switch result {
            case .success(let success):
                navigateToOTP = success
                isLoading = false
            case .failure(_):
                navigateToOTP = false
                isLoading = false
            }
        }
    }
}

// Modifier for Clear Button in TextField
struct ClearButtonModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
}
