//
//  OTPView.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI
import FirebaseAuth
import Swinject

struct OTPView: View {
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int? // To manage focus for each OTP box
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToHomePage = false
    @State private var navigateToGetPhoneUserDetailsFormPage = false
    @State private var navigateToPhoneNumberLogin = false
    @Environment(\.presentationMode) var presentationMode
    
    // Firebase verification ID passed from the previous view
    @StateObject private var viewModel: LoginViewModel
    let resolver: Resolver
    let phoneNumber: String
    init(resolver: Resolver, phoneNumber: String) {
        let viewModel = resolver.resolve(LoginViewModel.self)!
        _viewModel = StateObject(wrappedValue: viewModel)
        self.resolver = resolver
        self.phoneNumber = phoneNumber
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme
                    .ignoresSafeArea()
                GeometryReader { geometry in
                    LoginHeader(text: "Enter the OTP")
                    Spacer()
                    VStack {
                        // OTP Input Boxes
                        HStack(spacing: 10) {
                            ForEach(0..<6, id: \.self) { index in
                                TextField("", text: $otp[index])
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 50, height: 50)
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .cornerRadius(10)
                                    .focused($focusedField, equals: index) // Bind each field to its focus state
                                    .onChange(of: otp[index]) { newValue in
                                        // Allow only one digit in each OTP box and move to next field
                                        if newValue.count > 1 {
                                            otp[index] = String(newValue.prefix(1)) // Limit to one digit
                                        }
                                        if newValue.count == 1, index < 5 {
                                            focusedField = index + 1 // Move to next field if a digit is entered
                                        } else if newValue.isEmpty, index > 0 {
                                            focusedField = index - 1 // Move to previous field when backspace is pressed
                                        }
                                    }
                                    .onTapGesture {
                                        focusedField = index // Focus on the tapped field
                                    }
                            }
                        }
                        // Verify OTP Button
                        Button(action: {
                            verifyOTP()
                        }) {
                            Text("Verify OTP")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                        .padding()
                        .disabled(isLoading)
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        NavigationLink(destination: HomeView(resolver: resolver), isActive: $navigateToHomePage) {
                            EmptyView() // NavigationLink is triggered programmatically
                        }
                        NavigationLink(destination: LoginPhoneNumberView(resolver: resolver), isActive: $navigateToPhoneNumberLogin) {
                            EmptyView() // NavigationLink is triggered programmatically
                        }
                        NavigationLink(destination: PhoneNumberUserFormView(resolver: resolver, phoneNumber: phoneNumber), isActive: $navigateToGetPhoneUserDetailsFormPage) {
                            EmptyView() // NavigationLink is triggered programmatically
                        }
                        .navigationBarBackButtonHidden(true) // Hide default back button
                    }
                    .blur(radius: isLoading ? 3 : 0)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    .background(Color.gray.opacity(0.2))
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
                }
            }
            }
    }
    
    // Verify OTP Action
    func verifyOTP() {
        let otpString = otp.joined()
        
        if otpString.count == 6 {
            isLoading = true
            viewModel.verifyOTP(with: otpString) { result  in
                switch result {
                case .success(_):
                    handleLogin(phoneNumber: phoneNumber)
                    isLoading = false
                case .failure(let failure):
                    navigateToPhoneNumberLogin = true
                    isLoading = false
                }
            }
        } else {
            errorMessage = "Invalid OTP"
            showError = true
        }
    }
    
    func handleLogin(phoneNumber: String) {
        viewModel.checkIfUserExists(phoneNumber: phoneNumber) { exists, error in
            if let error = error {
                print("Error checking user existence: \(error.localizedDescription)")
                return
            }
            
            if exists {
                navigateToHomePage = true
            } else {
                navigateToGetPhoneUserDetailsFormPage = true
            }
        }
    }
}
