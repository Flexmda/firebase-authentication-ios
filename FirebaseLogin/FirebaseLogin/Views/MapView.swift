import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GMSMapView {
        // Configuración inicial del mapa
        let camera = GMSCameraPosition.camera(withLatitude: -34.92866, longitude: 138.60099, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Aquí puedes actualizar el mapa según sea necesario
    }
}
