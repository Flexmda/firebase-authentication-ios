//
//  FirebaseLoginApp.swift
//  FirebaseLogin
//
//  Created by Gilda on 23/02/23.
//

import SwiftUI
import FirebaseCore

@main
struct FirebaseLoginApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let vm = FirebaseLoginViewModel()
            ContentView()
                .environmentObject(vm)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      // Firebase configuration
      FirebaseApp.configure()

    return true
  }
}
