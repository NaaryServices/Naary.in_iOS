//
//  LoginHeader.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI

struct LoginHeader: View {
    let text: String
    @State var backHidden: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.theme
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        if !backHidden {
                            BackButtonView()
                        }
                        Spacer()
                    }
                    Text(text)
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                        .font(.headline)
                    
                }
            }
            .frame(height: geometry.size.width * 0.2)
        }
    }
}

#Preview {
    LoginHeader(text: "Login")
}
