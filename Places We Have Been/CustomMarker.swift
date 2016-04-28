//
//  CustomMarker.swift
//  Places We Have Been
//
//  Created by Michael Chen on 4/28/16.
//  Copyright © 2016 Michael Chen. All rights reserved.
//

import GoogleMaps

class CustomMarker: GMSMarker {
    
    var date:String
    
    init(date: String){
        self.date = date
        super.init()
    }
    
    func getDate() -> String {
        return date
    }
    
}