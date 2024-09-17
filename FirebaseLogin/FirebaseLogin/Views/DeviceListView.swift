//
//  DeviceListView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI
import FirebaseFirestore

struct DeviceListView: View {
    @State private var devices: [String] = [] // Lista de dispositivos
    @State private var selectedDeviceId: String?

    var body: some View {
        VStack {
            List(devices, id: \.self) { device in
                NavigationLink(
                    destination: RouteMapView(deviceId: device),
                    label: {
                        Text("Dispositivo: \(device)")
                    }
                )
            }
            .navigationTitle("Seleccionar Dispositivo")
            .onAppear {
                fetchDevices()
            }
        }
    }

    // Función para obtener la lista de dispositivos desde Firestore
    func fetchDevices() {
        let db = Firestore.firestore()
        db.collection("LocationHistory")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error obteniendo dispositivos: \(error.localizedDescription)")
                    return
                }

                // Extraer lista de dispositivos únicos
                let devicesSet = Set(snapshot?.documents.compactMap { doc -> String? in
                    return doc.data()["deviceId"] as? String
                } ?? [])
                
                devices = Array(devicesSet)
            }
    }
}
