//
//  PictureViewController.swift
//  Places We Have Been
//
//  Created by Jordan Lu on 4/3/16.
//  Copyright © 2016 Michael Chen. All rights reserved.
//

import UIKit
import CoreLocation

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
   
    var imagePicker:UIImagePickerController!
    var link: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PictureViewController.imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = image
        
        //Upload to imgur to get a link
        let base64String = UIImageJPEGRepresentation(image, 1.0)!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let clientId = "Client-ID f34fe8516f05db6"
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.imgur.com/3/upload")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = base64String.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            dispatch_async(dispatch_get_main_queue(), {
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                do {
                    let myData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    self.link = ((myData["data"] as! NSDictionary)["link"]) as! String
                    
//                    print(self.link)
                } catch {
                    print("ERROR")
                }
                
            })
        }
        
        task.resume()
    }

    @IBAction func submitClicked(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var currentTitles = defaults.objectForKey("titles") as! [String]
        var currentDescriptions = defaults.objectForKey("descriptions") as! [String]
        var currentUrls = defaults.objectForKey("urls") as! [String]
        var currentDateTimes = defaults.objectForKey("dateTimes") as! [String]
        var currentLocations = defaults.objectForKey("locations") as! [String]
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        let dateString = formatter.stringFromDate(NSDate())
        
        let locManager = CLLocationManager()
        var latitude: CLLocationDegrees!
        var longitude: CLLocationDegrees!
        
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
            latitude = locManager.location?.coordinate.latitude
            longitude = locManager.location?.coordinate.longitude
        } else {
            latitude = 0
            longitude = 0
        }
        
        let latLong = "" + String(latitude) + ", " + String(longitude)
        if (self.link == nil) {
            self.link = ""
        }
        
        currentTitles.append(self.titleTextField.text!)
        currentDescriptions.append(self.descriptionTextView.text)
        currentUrls.append(self.link)
        currentDateTimes.append(dateString)
        currentLocations.append(latLong)
        
        defaults.setValue(currentTitles, forKey:"titles")
        defaults.setValue(currentDescriptions, forKey:"descriptions")
        defaults.setValue(currentUrls, forKey:"urls")
        defaults.setValue(currentDateTimes, forKey:"dateTimes")
        defaults.setValue(currentLocations, forKey:"locations")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}