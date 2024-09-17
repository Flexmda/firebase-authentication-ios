//
//  FirebaseLoginApp.swift
//  FirebaseLogin
//
//  Created by Gilda on 23/02/23.
//

import FirebaseCore
import GoogleMaps
import SwiftUI

@main
struct FirebaseLoginApp: App {
    // Register app delegate for Firebase setup
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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Inicializa Firebase
        FirebaseApp.configure()
        
        // Inicializa Google Maps con tu API Key
        GMSServices.provideAPIKey("AIzaSyBI9YpWExtU377q9tCUB5nVOJqrV59-1lM")

        return true
    }
}
