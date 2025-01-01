//
//  NaaryApp.swift
//  Naary
//
//  Created by Chandana Sudha Madhuri Kandari on 01/01/25.
//

import SwiftUI
import Swinject

@main

struct NaaryApp: App {
    let container = Container()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Apply the AppAssembly to configure the container
        let appAssembly = AppAssembly()
        appAssembly.assemble(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(resolver: container)
        }
    }
}
