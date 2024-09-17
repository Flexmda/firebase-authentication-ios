//
//  MainMenuView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI
import FirebaseAuth

struct MainMenuView: View {
    @State private var isLoggedOut = false // Estado para manejar el cierre de sesión
    @State private var selectedDeviceId: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Opción para ver rutas
                    NavigationLink(destination: DeviceListView()) {
                        Text("Ver Rutas de Dispositivos")
                    }

                    // Opción para cerrar sesión
                    Button(action: logout) {
                        Text("Cerrar Sesión")
                            .foregroundColor(.red)
                    }
                }
                .navigationTitle("Menú Principal")
            }
            .alert(isPresented: $isLoggedOut) {
                Alert(title: Text("Cierre de sesión"),
                      message: Text("Has cerrado sesión correctamente."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    // Función para cerrar sesión
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch {
            print("Error cerrando sesión: \(error.localizedDescription)")
        }
    }
}
