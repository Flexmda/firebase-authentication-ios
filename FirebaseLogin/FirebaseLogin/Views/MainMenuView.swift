//
//  MainMenuView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI
import FirebaseAuth

struct MainMenuView: View {
    @State private var isLoggedOut = false  // Estado para manejar el cierre de sesión
    @State private var showUpdateUserView = false  // Estado para manejar la presentación de UpdateUserView
    @State private var selectedDeviceId: String = ""  // Almacenar el ID del dispositivo

    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Opción para ver rutas de dispositivos
                    NavigationLink(destination: DeviceListView()) {
                        Text("Ver Rutas de Dispositivos")
                    }

                    // Opción para actualizar la información del usuario
                    Button(action: {
                        showUpdateUserView = true  // Mostrar la vista de actualización de usuario
                    }) {
                        Text("Actualizar Información del Usuario")
                    }
                    .sheet(isPresented: $showUpdateUserView) {
                        UpdateUserView()
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
                Alert(
                    title: Text("Cierre de sesión"),
                    message: Text("Has cerrado sesión correctamente."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

