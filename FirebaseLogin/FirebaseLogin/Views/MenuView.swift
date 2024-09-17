//
//  MenuView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI

struct MenuView: View {
    @Binding var showingMenu: Bool
    let deviceId: String // Paramentro esperado

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Button(action: {
                    // Acción para cerrar sesión
                    print("Cerrar sesión")
                }) {
                    Text("Cerrar sesión")
                        .font(.headline)
                        .padding()
                }
                
                Button(action: {
                    // Acción para ir al mapa
                    print("Ir al mapa")
                    showingMenu = false // Ocultar menú al navegar
                }) {
                    Text("Ir al mapa")
                        .font(.headline)
                        .padding()
                }
                
                Button(action: {
                    // Acción para ver rutas
                    print("Ver rutas")
                    showingMenu = false // Ocultar menú al navegar
                }) {
                    Text("Ver rutas")
                        .font(.headline)
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarTitle("Menú", displayMode: .inline)
        }
    }
}

