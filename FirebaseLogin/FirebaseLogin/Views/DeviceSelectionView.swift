//
//  DeviceSelectionView.swift
//  FirebaseLogin
//
//  Created by Jose on 23/02/23.
//

import SwiftUI
import FirebaseFirestore

struct DeviceSelectionView: View {
    @State private var devices: [String] = []
    @State private var selectedDevice: String?
    @State private var showRouteView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Seleccione un dispositivo")
                    .font(.headline)
                    .padding()

                List(devices, id: \.self) { device in
                    Button(action: {
                        selectedDevice = device
                        showRouteView = true
                    }) {
                        Text(device)
                    }
                }
            }
            .navigationTitle("Dispositivos")
            .onAppear(perform: fetchDevices)
            .background(
                NavigationLink(
                    destination: RouteMapView(deviceId: selectedDevice ?? ""),
                    isActive: $showRouteView
                ) {
                    EmptyView()
                }
            )
        }
    }
    
    // Función para obtener todos los dispositivos únicos de la colección LocationHistory
    func fetchDevices() {
        let db = Firestore.firestore()
        db.collection("LocationHistory").getDocuments { snapshot, error in
            if let error = error {
                print("Error obteniendo dispositivos: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let deviceIds = Set(documents.compactMap { $0.data()["deviceId"] as? String })
            devices = Array(deviceIds)
        }
    }
}

