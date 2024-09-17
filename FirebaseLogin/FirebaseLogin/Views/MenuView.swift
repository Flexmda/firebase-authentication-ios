//
//  MenuView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI

struct MenuView: View {
    @Binding var showingMenu: Bool
    var deviceId: String
    
    @State private var navigateToRouteMap = false // Control de navegación a RouteMapView
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    // Lógica para ver las rutas
                    navigateToRouteMap = true
                }) {
                    Text("Ver Rutas")
                }
                .background(
                    NavigationLink(destination: RouteMapView(deviceId: deviceId), isActive: $navigateToRouteMap) {
                        EmptyView()
                    }
                )
                
                Button(action: {
                    // Cerrar sesión
                    FirebaseLoginViewModel().signOut()
                    showingMenu = false // Ocultar el menú al cerrar sesión
                }) {
                    Text("Cerrar Sesión")
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Menú")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showingMenu: .constant(true), deviceId: "device123")
    }
}

