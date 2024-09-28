import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var deviceLocations: [String: CLLocationCoordinate2D] = [:]  // Diccionario para almacenar ubicaciones de dispositivos
    @Published var deviceOwners: [String: (name: String, email: String)] = [:] // Diccionario para almacenar la información del propietario
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

        listenForDeviceLocations()  // Escuchar en tiempo real las ubicaciones de otros dispositivos
        listenForDeviceOwners()  // Escuchar información de los propietarios de dispositivos
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

    // Escuchar en tiempo real las ubicaciones de otros dispositivos
    private func listenForDeviceLocations() {
        db.collection("locations").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error obteniendo las ubicaciones de los dispositivos: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            // Procesar cada documento en la colección "locations"
            for document in documents {
                let data = document.data()
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double {
                    let deviceId = document.documentID
                    self.deviceLocations[deviceId] = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            }
        }
    }

    // Escuchar información de los propietarios de los dispositivos
    private func listenForDeviceOwners() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error obteniendo los propietarios de los dispositivos: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            for document in documents {
                let data = document.data()
                let userId = document.documentID
                let name = data["name"] as? String ?? "Desconocido"
                let email = data["email"] as? String ?? "Sin correo"
                
                // Almacenar la información de los propietarios de los dispositivos en el diccionario
                self.deviceOwners[userId] = (name: name, email: email)
            }
        }
    }

    // Manejo de errores de ubicación
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obteniendo la ubicación: \(error.localizedDescription)")
    }
}

