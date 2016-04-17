//
//  ViewController.swift
//  Places We Have Been
//
//  Created by Michael Chen on 3/31/16.
//  Copyright © 2016 Michael Chen. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6)
        mapView.myLocationEnabled = true
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        mapView.clear()
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        let handler = {
            (response : GMSReverseGeocodeResponse?, error: NSError?) -> Void in guard error == nil else { return }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = cameraPosition.target
                marker.title = result.lines![0] as String
                marker.snippet = result.lines![1] as String
                marker.map = mapView
            }
        }
    }
    
    
}
