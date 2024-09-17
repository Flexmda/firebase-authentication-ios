//
//  RouteMapView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI
import FirebaseFirestore
import MapKit

// Estructura que hace que la ubicación sea identificable
struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RouteMapView: View {
    let deviceId: String
    @State private var locations: [IdentifiableLocation] = []
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedDate = Date() // Estado para almacenar la fecha seleccionada

    var body: some View {
        VStack {
            // Selector de fechas
            DatePicker("Selecciona la fecha", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button(action: fetchLocationHistory) {
                Text("Cargar ruta del día seleccionado")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            // Mapa que muestra la ruta
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: locations) { location in
                MapPin(coordinate: location.coordinate, tint: .blue)
            }
            .navigationTitle("Ruta del día")
        }
    }

    // Función para obtener el historial de ubicaciones del día seleccionado
    func fetchLocationHistory() {
        let db = Firestore.firestore()
        let selectedDateString = getFormattedDate(date: selectedDate)

        db.collection("LocationHistory")
            .whereField("deviceId", isEqualTo: deviceId)
            .whereField("date", isEqualTo: selectedDateString)
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error obteniendo el historial de ubicaciones: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                let fetchedLocations = documents.compactMap { doc -> IdentifiableLocation? in
                    let data = doc.data()
                    if let latitude = data["latitude"] as? Double,
                       let longitude = data["longitude"] as? Double {
                        return IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    }
                    return nil
                }
                
                if let firstLocation = fetchedLocations.first {
                    mapRegion.center = firstLocation.coordinate
                }
                
                locations = fetchedLocations
            }
    }

    // Formatear la fecha seleccionada a "dd-MM-yyyy"
    func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}

