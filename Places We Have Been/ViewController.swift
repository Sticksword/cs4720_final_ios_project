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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("titles") == nil) {
            defaults.setValue([String](), forKey:"titles")
            defaults.setValue([String](), forKey:"descriptions")
            defaults.setValue([String](), forKey:"urls")
            defaults.setValue([String](), forKey:"dateTimes")
            defaults.setValue([String](), forKey:"locations")
        }
        
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        // The myLocation attribute of the mapView may be null
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        self.view = mapView
        
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

