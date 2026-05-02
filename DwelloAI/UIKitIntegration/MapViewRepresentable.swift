//
//  MapViewRepresentable.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 02.05.2026.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    let title: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = false
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        mapView.addAnnotation(annotation)
    }
}
