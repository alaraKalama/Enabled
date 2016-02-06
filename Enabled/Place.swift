//
//  Place.swift
//  Enabled
//
//  Created by Bianka on 2/5/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

class Place: NSObject {

    var ID: String!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var name: String!
    var formattedAddress: String!
    var types: [AnyObject]!
    var numberOfVoter: NSInteger!
    var accessibilityLevel: Float!
    var WC_Access: Float!
    
    override init() {
        self.types = []
    }
    
    class func PlaceFromGMSPlace(gmsPlace: GMSPlace) -> Place {
        let place = Place()
        place.ID = gmsPlace.placeID
        place.types = gmsPlace.types
        place.name = gmsPlace.name
        place.formattedAddress = gmsPlace.formattedAddress
        place.latitude = gmsPlace.coordinate.latitude
        place.longitude = gmsPlace.coordinate.longitude
        place.types = gmsPlace.types
        place.accessibilityLevel = 40.5
        place.WC_Access = 0
        return place
    }
    
    func placeAsDictionaty() -> NSMutableDictionary{
        let dict = NSMutableDictionary.init(capacity: 12)
        dict.setValue(self.ID, forKey: "ID")
        dict.setValue(self.name, forKey: "name")
        dict.setValue(self.latitude, forKey: "latitude")
        dict.setValue(self.longitude, forKey: "longitude")
        dict.setValue(self.formattedAddress, forKey: "formattedAddress")
        dict.setValue(self.numberOfVoter, forKey: "numberOfVoter")
        dict.setValue(self.accessibilityLevel, forKey: "accessibilityLevel")
        dict.setValue(self.WC_Access, forKey: "WC_Access")
        dict.setValue(self.types, forKey: "types")
        return dict
    }
}
