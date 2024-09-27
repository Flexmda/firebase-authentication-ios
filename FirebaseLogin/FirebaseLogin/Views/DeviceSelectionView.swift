import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DeviceSelectionView: View {
    @State private var devices: [(deviceId: String, ownerName: String, ownerEmail: String)] = []  // Almacena el dispositivo y su propietario
    @State private var selectedDevice: String?
    @State private var showRouteView = false
    @State private var isShowingScanner = false  // Para mostrar el escáner de QR
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Seleccione un dispositivo")
                    .font(.headline)
                    .padding()

                List(devices, id: \.deviceId) { device in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Dispositivo: \(device.deviceId)")
                            Text("Propietario: \(device.ownerName) (\(device.ownerEmail))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            deleteDevice(deviceId: device.deviceId)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .onTapGesture {
                        selectedDevice = device.deviceId
                        showRouteView = true
                    }
                }
                .navigationTitle("Dispositivos")

                // Botón para escanear QR y registrar un dispositivo
                Button(action: {
                    isShowingScanner = true
                }) {
                    Text("Registrar Dispositivo")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .onAppear(perform: fetchDevices)
            .background(
                NavigationLink(
                    destination: RouteMapView(deviceId: selectedDevice ?? ""),
                    isActive: $showRouteView
                ) {
                    EmptyView()
                }
            )
            .sheet(isPresented: $isShowingScanner) {
                QRCodeScannerView { result in
                    isShowingScanner = false
                    switch result {
                    case .success(let scannedUUID):
                        registerDevice(uuid: scannedUUID)
                    case .failure(let error):
                        alertMessage = "Error escaneando QR: \(error.localizedDescription)"
                        showingAlert = true
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Dispositivo"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Función para obtener todos los dispositivos registrados y sus propietarios
    func fetchDevices() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                alertMessage = "Error obteniendo dispositivos: \(error.localizedDescription)"
                showingAlert = true
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            // Obtener los dispositivos de la subcolección "devices" de cada usuario
            devices = []
            for document in documents {
                let userId = document.documentID
                let userData = document.data()
                let ownerName = userData["name"] as? String ?? "Desconocido"
                let ownerEmail = userData["email"] as? String ?? "Desconocido"
                
                let userDevicesRef = db.collection("users").document(userId).collection("devices")
                userDevicesRef.getDocuments { deviceSnapshot, error in
                    if let error = error {
                        print("Error obteniendo dispositivos: \(error)")
                        return
                    }
                    
                    guard let deviceDocuments = deviceSnapshot?.documents else { return }
                    
                    for deviceDoc in deviceDocuments {
                        let deviceId = deviceDoc.documentID
                        devices.append((deviceId: deviceId, ownerName: ownerName, ownerEmail: ownerEmail))
                    }
                }
            }
        }
    }
    
    // Función para registrar un nuevo dispositivo escaneado
    func registerDevice(uuid: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "Error: No se encontró un usuario autenticado."
            showingAlert = true
            return
        }

        let db = Firestore.firestore()
        let deviceDoc = db.collection("users").document(userId).collection("devices").document(uuid)

        deviceDoc.setData([
            "deviceName": UIDevice.current.name,
            "registeredAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                alertMessage = "Error al registrar dispositivo: \(error.localizedDescription)"
                showingAlert = true
            } else {
                alertMessage = "Dispositivo registrado exitosamente."
                showingAlert = true
                fetchDevices()  // Actualizar la lista de dispositivos después de registrar uno nuevo
            }
        }
    }

    // Función para eliminar un dispositivo
    func deleteDevice(deviceId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "Error: No se encontró un usuario autenticado."
            showingAlert = true
            return
        }

        let db = Firestore.firestore()
        let deviceDoc = db.collection("users").document(userId).collection("devices").document(deviceId)

        deviceDoc.delete { error in
            if let error = error {
                alertMessage = "Error eliminando el dispositivo: \(error.localizedDescription)"
                showingAlert = true
            } else {
                alertMessage = "Dispositivo eliminado exitosamente."
                showingAlert = true
                fetchDevices()  // Actualizar la lista de dispositivos después de eliminar uno
            }
        }
    }
}

