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
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(38.03, longitude: -78.51, zoom: 6)

        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("titles") == nil) {
            defaults.setValue([String](), forKey:"titles")
            defaults.setValue([String](), forKey:"descriptions")
            defaults.setValue([String](), forKey:"urls")
            defaults.setValue([String](), forKey:"dateTimes")
            defaults.setValue([String](), forKey:"locations") // "lat, lon" strings
        }

        mapView.myLocationEnabled = true
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(38.03, -78.51)
        marker.title = "UVA"
        marker.snippet = "wahoowa"
        marker.map = mapView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()

        var titles = defaults.arrayForKey("titles")!
        var descriptions = defaults.arrayForKey("descriptions")!
        var locations = defaults.arrayForKey("locations")!
        var dates = defaults.arrayForKey("dateTimes")!
        var urls = defaults.arrayForKey("urls")!
        for i in 0..<titles.count {
            let marker = CustomMarker(date: dates[i] as! String)
            var locArr = locations[i].componentsSeparatedByString(", ")
            marker.position = CLLocationCoordinate2DMake(Double(locArr[0])!, Double(locArr[1])!)
            marker.title = titles[i] as? String
            marker.snippet = descriptions[i] as? String
            marker.map = mapView
        }
        
    }

//    REFERENCE:
//    let userNameKeyConstant = "userNameKey"
//    
//    @IBAction func writeButton(sender: UIButton)
//    {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject("Coding Explorer", forKey: userNameKeyConstant)
//    }
//    @IBAction func readButton(sender: UIButton)
//    {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let name = defaults.stringForKey(userNameKeyConstant)
//        {
//            println(name)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: GMSMapViewDelegate {
    
//    indicates that the camera position is about to change. If the gesture argument is set to YES, this is due to a user performing a natural gesture on the GMSMapView, such as a pan or tilt. Otherwise, NO indicates that this is part of a programmatic change - for example, via methods such as animateToCameraPosition: or updating the map's layer directly. This may also be NO if a user has tapped on the My Location or compass buttons, which generate animations that change the camera.
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
//        mapView.clear()
    }
    
//    is called repeatedly during a gesture or animation, always after a call to mapView:willMove:. It is passed the intermediate camera position.
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
//     is invoked once the camera position on GMSMapView becomes idle, and specifies the relevant camera position. At this point, all animations and gestures have stopped.
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        _ = {
            (response : GMSReverseGeocodeResponse?, error: NSError?) -> Void in guard error == nil else { return }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = cameraPosition.target
                marker.title = result.lines![0] as String
                marker.snippet = result.lines![1] as String
                marker.map = mapView
            }
            print("test")
        }
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc : DetailsViewController = storyboard.instantiateViewControllerWithIdentifier("detailsViewController") as! DetailsViewController
        
        let m = marker as! CustomMarker
        vc.pictureTitle = m.title
//        vc.pictureDescription = marker.description
        vc.pictureDescription = m.snippet
        vc.location = m.position
        vc.date = m.getDate()
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
}
