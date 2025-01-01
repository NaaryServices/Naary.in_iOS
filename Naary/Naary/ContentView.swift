//
//  ContentView.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI
import Swinject

struct ContentView: View {
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var body: some View {
        LoginSelectionView(resolver: resolver)
    }
}

#Preview {
    ContentView(resolver: Container())
}
