//
//  PlaceMarker.swift
//  Enabled
//
//  Created by Bianka on 2/3/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import Foundation
import GoogleMaps

class PlaceMarker : GMSMarker {
    let place: GMSPlace
    //let coordinate2D: CLLocationCoordinate2D
    
    init(place: GMSPlace) {
        self.place = place
        super.init()
        position = place.coordinate
        icon = UIImage(named: "pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        //appearAnimation = kGMSMarkerAnimationPop
    }
}