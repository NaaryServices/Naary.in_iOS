import SwiftUI
import Swinject

struct HomeView: View {
    @State private var isLoggedOut = false
    @State private var displayName: String = "Loading..."
    
    @StateObject private var viewModel: HomeViewModel
    let resolver: Resolver
    init(resolver: Resolver) {
        let viewModel = resolver.resolve(HomeViewModel.self)!
        _viewModel = StateObject(wrappedValue: viewModel)
        self.resolver = resolver
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                HStack {
                    VStack(spacing: 0) {
                        LoginHeader(text: "Welcome! \(displayName)", backHidden: true)
                            .font(.system(size: 14, weight: .bold))
                            .multilineTextAlignment(.center)
                            .onAppear {
                                getUserDisplayName()
                            }
                        Button(action: logout) {
                            Text("Logout")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                        NavigationLink(destination: LoginSelectionView(resolver: resolver), isActive: $isLoggedOut) {
                            EmptyView() // NavigationLink is triggered programmatically
                        }
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
    
    private func logout() {
        // Logout logic here
        viewModel.logout { result in
            switch result {
            case .success(let success):
                isLoggedOut = success
            case .failure(_):
                isLoggedOut = false
            }
        }
    }
    
    private func getUserDisplayName() {
        if let displayName = viewModel.getUserInfoLocal()?.displayName, !displayName.isEmpty {
            self.displayName = displayName
        } else {
            DispatchQueue.main.async {
                viewModel.getUserDetails { user, error in
                    if let user = user, error == nil {
                        displayName = user.displayName
                    }
                }
            }
        }
    }
}
