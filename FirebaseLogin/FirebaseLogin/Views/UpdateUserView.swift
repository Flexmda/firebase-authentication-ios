import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import CoreImage.CIFilterBuiltins

struct UpdateUserView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var deviceName: String = UIDevice.current.name  // Nombre del dispositivo actual
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = true  // Manejar la carga inicial de datos
    @State private var deviceUUID: String = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown UUID"  // UUID del dispositivo
    
    private let db = Firestore.firestore()
    
    // Generador de códigos QR
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        NavigationView {
            if isLoading {
                // Muestra un indicador de carga mientras se obtienen los datos
                ProgressView("Cargando datos del usuario...")
                    .onAppear {
                        fetchUserInfo()
                    }
            } else {
                Form {
                    Section(header: Text("Información de Usuario")) {
                        TextField("Nombre", text: $name)
                        Text(email) // El correo es leído desde Firestore, no editable
                            .foregroundColor(.gray)
                    }

                    Section(header: Text("Información del Dispositivo")) {
                        TextField("Nombre del Dispositivo", text: $deviceName)
                        
                        // Mostrar el UUID del dispositivo
                        Text("UUID del Dispositivo: \(deviceUUID)")
                            .foregroundColor(.gray)
                        
                        // Mostrar el QR generado a partir del UUID
                        if let qrImage = generateQRCode(from: deviceUUID) {
                            Image(uiImage: qrImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                    }

                    Button(action: {
                        updateUserInfo()
                    }) {
                        Text("Actualizar Información")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Actualización"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationBarTitle("Actualizar Información", displayMode: .inline)
            }
        }
    }

    // Obtener la información actual del usuario desde Firestore
    private func fetchUserInfo() {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "Error: No se encontró un usuario autenticado."
            showingAlert = true
            isLoading = false
            return
        }

        let userDoc = db.collection("users").document(userId)
        userDoc.getDocument { document, error in
            if let error = error {
                alertMessage = "Error obteniendo la información del usuario: \(error.localizedDescription)"
                showingAlert = true
                isLoading = false
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                name = data?["name"] as? String ?? ""
                email = data?["email"] as? String ?? Auth.auth().currentUser?.email ?? "" // Usar el correo autenticado si no está en Firestore
                isLoading = false
            } else {
                alertMessage = "No se encontraron datos del usuario."
                showingAlert = true
                isLoading = false
            }
        }
    }

    // Actualizar la información del usuario y el dispositivo
    private func updateUserInfo() {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "Error: No se encontró un usuario autenticado."
            showingAlert = true
            return
        }

        let userDoc = db.collection("users").document(userId)

        // Actualizar la información del usuario (solo el nombre, el correo no debe cambiar)
        userDoc.setData([
            "name": name
        ], merge: true) { error in
            if let error = error {
                alertMessage = "Error actualizando la información del usuario: \(error.localizedDescription)"
                showingAlert = true
                return
            }

            // Actualizar el nombre del dispositivo
            updateDeviceName(userId: userId)

            alertMessage = "Información actualizada exitosamente."
            showingAlert = true
        }
    }

    // Actualizar el nombre del dispositivo en la subcolección devices
    private func updateDeviceName(userId: String) {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
        let deviceDoc = db.collection("users").document(userId).collection("devices").document("device_\(deviceId)")

        deviceDoc.setData([
            "deviceName": deviceName,
            "lastUpdated": Timestamp(date: Date()),
            "deviceUUID": deviceUUID  // Guardamos el UUID del dispositivo
        ], merge: true) { error in
            if let error = error {
                alertMessage = "Error actualizando el nombre del dispositivo: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Nombre del dispositivo actualizado correctamente.")
            }
        }
    }

    // Función para generar el código QR a partir del UUID del dispositivo
    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return nil
    }
}

