//
//  fitpickApp.swift
//  fitpick
//
//  Created by Amuel Ryco Nidoy on 1/9/26.
//

import SwiftUI

@main
struct fitpickApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(appState)
        }
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}



