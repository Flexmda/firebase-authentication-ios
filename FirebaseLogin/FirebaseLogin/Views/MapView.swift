//
//  MapView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @State private var showingMenu = false // Para controlar el menú

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: -34.92866, longitude: 138.60099, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if let location = locationManager.currentLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
            mapView.animate(to: camera)

            // Añadir un marcador en la ubicación actual
            mapView.clear() // Eliminar marcadores antiguos
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            marker.map = mapView
        }
    }

    var body: some View {
        ZStack {
            // Integrar el MapView con SwiftUI
            MapContainerView(locationManager: locationManager) // Vista contenedora
                .edgesIgnoringSafeArea(.all) // Aquí usamos SwiftUI para que ocupe toda la pantalla

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
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: -34.92866, longitude: 138.60099, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if let location = locationManager.currentLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
            mapView.animate(to: camera)

            // Añadir un marcador en la ubicación actual
            mapView.clear() // Eliminar marcadores antiguos
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            marker.map = mapView
        }
    }
}

