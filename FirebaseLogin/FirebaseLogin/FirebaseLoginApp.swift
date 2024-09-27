import FirebaseCore
import GoogleMaps
import SwiftUI

@main
struct FirebaseLoginApp: App {
    // Registrar el AppDelegate para configurar Firebase y Google Maps
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let vm = FirebaseLoginViewModel()  // Inicializamos el ViewModel
            ContentView()  // La vista principal de la app
                .environmentObject(vm)  // Pasamos el ViewModel como EnvironmentObject
        }
    }
}

// Clase AppDelegate que inicializa Firebase y Google Maps
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

