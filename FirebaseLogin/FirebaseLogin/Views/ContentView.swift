import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var vm: FirebaseLoginViewModel
    @State private var showingMenu = false  // Controla la visibilidad del menú

    var body: some View {
        NavigationView {
            // Verifica si el usuario ha iniciado sesión
            if vm.signedIn {
                ZStack {
                    // Mostrar el mapa si está autenticado
                    MapView()
                        .edgesIgnoringSafeArea(.all)

                    // Botón para abrir el menú
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
                // Mostrar la vista de inicio de sesión si el usuario no está autenticado
                SignInView()
            }
        }
        .onAppear {
            // Escucha cambios en el estado de autenticación
            vm.listenToAuthState()
        }
        .sheet(isPresented: $showingMenu) {
            // Presenta el menú
            MenuView(showingMenu: $showingMenu, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device")
                .environmentObject(vm)  // Pasamos el ViewModel al menú
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseLoginViewModel())
    }
}

