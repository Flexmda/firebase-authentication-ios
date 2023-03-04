//
//  FirebaseTestApp.swift
//  FirebaseTest
//
//  Created by Gilda on 21/02/23.
//

import SwiftUI

import SwiftUI
import Firebase


@main
struct FirebaseTestApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      FirebaseApp.configure()

    return true
  }
}

