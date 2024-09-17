//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: FirebaseLoginViewModel
    @State private var showingMenu = false // Para controlar el menú

    var body: some View {
        NavigationView {
            if vm.signedIn {
                ZStack {
                    // Mostrar el mapa después de iniciar sesión
                    MapView()
                        .edgesIgnoringSafeArea(.all) // Para que el mapa ocupe toda la pantalla

                    // Botón para mostrar el menú
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showingMenu = true // Mostrar menú
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .padding()
                        }
                        Spacer()
                    }
                }
            } else {
                // Si no está logueado, muestra la pantalla de inicio de sesión
                SignInView()
            }
        }
        .onAppear {
            vm.signedIn = vm.isSignedIn
        }
        .sheet(isPresented: $showingMenu) {
            MenuView(showingMenu: $showingMenu, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseLoginViewModel())
    }
}

