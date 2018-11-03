//
//  MapViewController.swift
//  weather-forecast-extension
//
//  Created by Klaudia on 03/11/2018.
//  Copyright © 2018 Klaudia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let marker = MKPointAnnotation()
        marker.title = self.name
        marker.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        self.mapView.addAnnotation(marker)
        self.mapView.setCenter(marker.coordinate, animated: true)
    }
}
