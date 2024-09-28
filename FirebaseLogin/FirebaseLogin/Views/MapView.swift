import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @State private var showingMenu = false // Para controlar el menú
    @State private var didCenterOnUserLocation = false // Controla el centrado inicial en la ubicación del usuario

    // Crear una instancia de GMSMapView como propiedad @State para mantener la referencia
    @State private var mapView = GMSMapView()

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: -34.92866, longitude: 138.60099, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Solo añadir o actualizar los marcadores sin eliminar todos cada vez
        updateMarkers(mapView: mapView)
    }

    private func updateMarkers(mapView: GMSMapView) {
        // Añadir marcador para la ubicación actual
        if let location = locationManager.currentLocation {
            let currentLocationMarker = GMSMarker(position: location)
            currentLocationMarker.title = "Mi ubicación"
            currentLocationMarker.map = mapView

            // Evitar recenter en la ubicación; movemos el ajuste de `didCenterOnUserLocation` fuera de este ciclo.
            if !didCenterOnUserLocation {
                DispatchQueue.main.async {
                    let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
                    mapView.animate(to: camera)
                    didCenterOnUserLocation = true
                }
            }
        }

        // Añadir o actualizar marcadores para las ubicaciones de los dispositivos registrados
        for (deviceId, location) in locationManager.deviceLocations {
            if let ownerInfo = locationManager.deviceOwners[deviceId] {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                marker.title = "Dispositivo: \(deviceId)\nPropietario: \(ownerInfo.name) (\(ownerInfo.email))"
                marker.map = mapView
            } else {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                marker.title = "Dispositivo: \(deviceId)"
                marker.map = mapView
            }
        }
    }

    var body: some View {
        ZStack {
            // Integrar el MapView con SwiftUI
            MapContainerView(locationManager: locationManager, mapView: $mapView) // Vista contenedora
                .edgesIgnoringSafeArea(.all) // Aquí usamos SwiftUI para que ocupe toda la pantalla
                .onAppear {
                    // Establecemos didCenterOnUserLocation a false al iniciar para permitir centrado la primera vez.
                    didCenterOnUserLocation = false
                }

            // Botón de menú
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
        .sheet(isPresented: $showingMenu) {
            // Pasar el deviceId al menú
            MenuView(showingMenu: $showingMenu, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device")
        }
    }
}

// Vista contenedora para manejar GMSMapView dentro de SwiftUI
struct MapContainerView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @Binding var mapView: GMSMapView

    func makeUIView(context: Context) -> GMSMapView {
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Ya no modificamos mapView aquí, todo se maneja en `updateMarkers` en MapView.
    }
}

