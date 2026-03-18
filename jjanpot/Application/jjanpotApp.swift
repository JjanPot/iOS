//
//  jjanpotApp.swift
//  jjanpot
//
//  Created by 임주희 on 3/11/26.
//

import SwiftUI

@main
struct jjanpotApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            AppDIContainer.shared.makeLoginView(onDismiss: {})
            
        }
    }
}

