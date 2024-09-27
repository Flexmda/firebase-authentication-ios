import SwiftUI

struct MenuView: View {
    @Binding var showingMenu: Bool
    @EnvironmentObject var vm: FirebaseLoginViewModel  // Para acceder a la función de cierre de sesión
    var deviceId: String

    var body: some View {
        NavigationView {
            List {
                // Navegación al Mapa en Tiempo Real
                NavigationLink(destination: MapView()) {
                    Text("Ver Mapa en Tiempo Real")
                }

                // Navegación a la vista de actualización de perfil
                NavigationLink(destination: UpdateUserView()) {
                    Text("Actualizar Perfil")
                }

                // Navegación a la vista de selección de dispositivo para ver historial
                NavigationLink(destination: DeviceSelectionView()) {
                    Text("Seleccionar Dispositivo para Historial")
                }

                // Opción para cerrar sesión
                Button(action: {
                    vm.signOut()  // Cerrar sesión
                    showingMenu = false  // Cerrar el menú después de cerrar sesión
                }) {
                    Text("Cerrar Sesión")
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Menú", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingMenu = false  // Cerrar el menú
            }) {
                Text("Cerrar")
            })
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showingMenu: .constant(true), deviceId: "TestDeviceId")
            .environmentObject(FirebaseLoginViewModel())
    }
}

