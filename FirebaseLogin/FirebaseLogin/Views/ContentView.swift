//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: FirebaseLoginViewModel

    var body: some View {
        NavigationView {
            if vm.signedIn {
                // Mostrar el mapa después de iniciar sesión
                MapView()
                    .edgesIgnoringSafeArea(.all) // Para que el mapa ocupe toda la pantalla
            } else {
                // Si no está logueado, muestra la pantalla de inicio de sesión
                SignInView()
            }
        }
        .onAppear {
            vm.signedIn = vm.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseLoginViewModel())
    }
}
