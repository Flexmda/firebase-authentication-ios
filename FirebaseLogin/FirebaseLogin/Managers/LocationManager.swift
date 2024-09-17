import CoreLocation
import FirebaseFirestore
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    // Nombre del dispositivo, se puede asignar manualmente o generar de otra manera
    var deviceName: String = "MyDeviceName"

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true // Habilitar actualizaciones en segundo plano
        locationManager.pausesLocationUpdatesAutomatically = false // No pausar las actualizaciones automáticamente
        locationManager.requestAlwaysAuthorization() // Solicitar permisos de ubicación siempre
        locationManager.startUpdatingLocation() // Empezar a recibir actualizaciones de ubicación
        startMonitoringSignificantLocationChanges() // Rastrear cambios importantes en segundo plano
        setDeviceNameIfNeeded() // Guardar nombre de dispositivo si no existe
    }

    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }

    // Método llamado cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate
        saveLocationToFirestore(location: location.coordinate) // Guardar ubicación actual
        saveLocationHistoryToFirestore(location: location.coordinate) // Guardar historial
        print("Ubicación actualizada: \(location.coordinate)")
    }

    // Guardar la ubicación actual en Firestore
    private func saveLocationToFirestore(location: CLLocationCoordinate2D) {
        let docRef = db.collection("locations").document("device_\(UIDevice.current.identifierForVendor!.uuidString)")
        docRef.setData([
            "latitude": location.latitude,
            "longitude": location.longitude,
            "timestamp": Timestamp(date: Date()), // Cambiar a Timestamp con la fecha actual
            "deviceName": deviceName // Guardar el nombre del dispositivo
        ], merge: true) { error in
            if let error = error {
                print("Error guardando la ubicación en Firestore: \(error)")
            } else {
                print("Ubicación guardada exitosamente en Firestore.")
            }
        }
    }

    // Guardar la ubicación en un array dentro del historial
    private func saveLocationHistoryToFirestore(location: CLLocationCoordinate2D) {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
        
        let locationData: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude,
            "timestamp": Timestamp(date: Date()) // Usar Timestamp con la fecha actual
        ]
        
        let docRef = db.collection("LocationHistory").document("device_\(deviceId)")
        docRef.setData([
            "deviceName": deviceName, // Guardar el nombre del dispositivo
            "locations": FieldValue.arrayUnion([locationData]) // Añadir la nueva ubicación al array
        ], merge: true) { error in
            if let error = error {
                print("Error guardando historial de ubicación: \(error.localizedDescription)")
            } else {
                print("Historial de ubicación actualizado exitosamente.")
            }
        }
    }

    // Establecer el nombre del dispositivo en Firestore si aún no está configurado
    private func setDeviceNameIfNeeded() {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
        let docRef = db.collection("LocationHistory").document("device_\(deviceId)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let existingName = document.data()?["deviceName"] as? String {
                    print("Nombre del dispositivo existente: \(existingName)")
                } else {
                    // No hay un nombre guardado, asignar uno
                    docRef.setData(["deviceName": self.deviceName], merge: true) { error in
                        if let error = error {
                            print("Error asignando el nombre del dispositivo: \(error.localizedDescription)")
                        } else {
                            print("Nombre del dispositivo asignado exitosamente.")
                        }
                    }
                }
            } else if let error = error {
                print("Error obteniendo documento: \(error.localizedDescription)")
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

