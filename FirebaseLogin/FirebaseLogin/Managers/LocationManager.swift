import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    // Nombre del dispositivo o el nombre que desees asignar manualmente
    var deviceName: String = "MyDeviceName"

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true  // Permitir actualizaciones en segundo plano
        locationManager.pausesLocationUpdatesAutomatically = false  // No pausar las actualizaciones
        locationManager.requestAlwaysAuthorization()  // Solicitar permisos para ubicación en todo momento
        locationManager.startUpdatingLocation()  // Iniciar la actualización de la ubicación
    }

    // Método delegado llamado cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate
        saveLocationToFirestore(location: location.coordinate)
        print("Ubicación actualizada: \(location.coordinate)")
    }

    // Guardar la ubicación actual en Firestore asociada al usuario autenticado
    private func saveLocationToFirestore(location: CLLocationCoordinate2D) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No se encontró un usuario autenticado.")
            return
        }

        let docRef = db.collection("locations").document("user_\(userId)")
        docRef.setData([
            "latitude": location.latitude,
            "longitude": location.longitude,
            "timestamp": Timestamp(date: Date()),
            "deviceName": deviceName
        ], merge: true) { error in
            if let error = error {
                print("Error guardando la ubicación en Firestore: \(error.localizedDescription)")
            } else {
                print("Ubicación guardada exitosamente en Firestore.")
            }
        }
    }

    // Manejo de errores de ubicación
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obteniendo la ubicación: \(error.localizedDescription)")
    }
}

