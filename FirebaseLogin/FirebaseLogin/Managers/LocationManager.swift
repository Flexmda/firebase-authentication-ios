import CoreLocation
import FirebaseFirestore
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true // Habilitar actualizaciones en segundo plano
        locationManager.pausesLocationUpdatesAutomatically = false // No pausar las actualizaciones automáticamente
        locationManager.requestAlwaysAuthorization() // Solicitar permisos de ubicación siempre
        locationManager.startUpdatingLocation() // Empezar a recibir actualizaciones de ubicación
        startMonitoringSignificantLocationChanges() // Rastrear cambios importantes en segundo plano
    }

    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }

    // Método llamado cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate
        saveLocationToFirestore(location: location.coordinate)
        print("Ubicación actualizada: \(location.coordinate)")
    }

    // Guardar la ubicación en Firestore
    private func saveLocationToFirestore(location: CLLocationCoordinate2D) {
        let docRef = db.collection("locations").document("device_\(UIDevice.current.identifierForVendor!.uuidString)")
        docRef.setData([
            "latitude": location.latitude,
            "longitude": location.longitude,
            "timestamp": FieldValue.serverTimestamp()
        ], merge: true) { error in
            if let error = error {
                print("Error guardando la ubicación en Firestore: \(error)")
            } else {
                print("Ubicación guardada exitosamente en Firestore.")
            }
        }
    }

    // Manejar errores de localización
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obteniendo la ubicación: \(error.localizedDescription)")
    }

    // Registrar tarea de fondo para continuar rastreando en segundo plano
    func applicationDidEnterBackground(_ application: UIApplication) {
        startBackgroundTask()
    }
    
    func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
}
