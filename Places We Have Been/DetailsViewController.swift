//
//  DetailsViewController.swift
//  Places We Have Been
//
//  Created by Jordan Lu on 4/27/16.
//  Copyright © 2016 Michael Chen. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController : UIViewController {
    
    var pictureTitle : String!
    var pictureDescription: String!
    var location: CLLocationCoordinate2D!
    var date: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = pictureTitle
        self.descriptionLabel.text = pictureDescription
        self.locationLabel.text = String(location)
        self.dateTimeLabel.text = date

    }
}