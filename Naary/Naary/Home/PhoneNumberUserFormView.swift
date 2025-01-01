import SwiftUI
import Swinject

struct PhoneNumberUserFormView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var errorMessage: String = ""
    @State private var isSubmitted: Bool = false
    @State private var navigateToHomeView: Bool = false
    
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
        NavigationView {
            ZStack {
                Color.theme
                    .ignoresSafeArea()
                VStack {
                    LoginHeader(text: "Enter your name")
                    Spacer()
                    VStack(spacing: 50) {
                        TextField("First Name", text: $firstName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .onChange(of: firstName) { _ in
                                errorMessage = ""
                            }
                        
                        TextField("Last Name", text: $lastName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .onChange(of: lastName) { _ in
                                errorMessage = ""
                            }
                        TextField("Email(Optional)", text: $email)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .onChange(of: firstName) { _ in
                                errorMessage = ""
                            }
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.top)
                        }
                        
                        Spacer()
                        Button(action: nextButtonClicked) {
                            Text("Next")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .disabled(firstName.isEmpty || lastName.isEmpty)
                        .opacity(firstName.isEmpty || lastName.isEmpty ? 0.5 : 1.0)
                        NavigationLink(destination: HomeView(resolver: resolver), isActive: $navigateToHomeView) {
                            EmptyView() // NavigationLink is triggered programmatically
                        }
                    }
                    .navigationTitle("Details")
                    .padding()
                }
            }
        }
    }
    
    private func nextButtonClicked() {
        if firstName.isEmpty || lastName.isEmpty {
            errorMessage = "First Name and Last Name are required."
        } else {
            isSubmitted = true
            let user = PhoneNumberUser(phoneNumber: phoneNumber, email: email, displayName: "\(firstName), \(lastName)")
            viewModel.saveUserIfFirstTime(user: user) { success, error in
                if success {
                    navigateToHomeView = true
                } else {
                    viewModel.save(user: user)
                }
                if let error = error {
                    firstName = ""
                    lastName = ""
                    email = ""
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    PhoneNumberUserFormView(resolver: Container(), phoneNumber: "")
}
