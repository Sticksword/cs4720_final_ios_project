//
//  PictureViewController.swift
//  Places We Have Been
//
//  Created by Jordan Lu on 4/3/16.
//  Copyright © 2016 Michael Chen. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
   
    var imagePicker:UIImagePickerController!
    
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
        var link = ""
        
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
                    link = ((myData["data"] as! NSDictionary)["link"]) as! String
                    
                    print(link)
                } catch {
                    print("ERROR")
                }
                
            })
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}