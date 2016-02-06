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
    var street: String!
    var strNumber: String!
    var city: String!
    var country: String!
    var numberOfVoter: NSInteger!
    var accessibilityLevel: Float!
    var WC_Access: Float!
    
    func placeAsDictionaty() -> NSMutableDictionary{
        let dict = NSMutableDictionary.init(capacity: 12)
        dict.setValue(self.ID, forKey: "ID")
        dict.setValue(self.name, forKey: "name")
        dict.setValue(self.latitude, forKey: "latitude")
        dict.setValue(self.longitude, forKey: "longitude")
        dict.setValue(self.street, forKey: "street")
        dict.setValue(self.strNumber, forKey: "strNumber")
        dict.setValue(self.city, forKey: "city")
        dict.setValue(self.country, forKey: "country")
        dict.setValue(self.numberOfVoter, forKey: "numberOfVoter")
        dict.setValue(self.accessibilityLevel, forKey: "accessibilityLevel")
        dict.setValue(self.WC_Access, forKey: "WC_Access")
        return dict
    }
}
