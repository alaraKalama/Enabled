//
//  Place.swift
//  Enabled
//
//  Created by Bianka on 2/5/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class Place: NSObject {

    var ID: String!
    var name: String!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var formattedAddress: String!
    var types: [AnyObject]!
    var images: [AnyObject]!
    var comments: [AnyObject]!
    var numberOfVoter: Int!
    var sumOfAccessibilityVote: Int!
    var sumOfWcVote: Int!
    var accessibilityLevel: Float!
    var WC_Access: Float!
    
    override init() {
        self.types = []
        self.comments = []
        self.images = []
    }
    
    class func PlaceFromDataSnapshot(snap: FDataSnapshot) -> Place{
        let place = Place()
        place.ID = snap.value["ID"] as? String
        place.name = snap.value["name"] as? String
        place.latitude = snap.value["latitude"] as? CLLocationDegrees
        place.longitude = snap.value["longitude"] as? CLLocationDegrees
        place.formattedAddress = snap.value["formattedAddress"] as? String
        place.numberOfVoter = snap.value["numberOfVoter"] as? Int
        place.sumOfAccessibilityVote = snap.value["sumOfAccessibilityVote"] as? Int
        place.sumOfWcVote = snap.value["sumOfWcVote"] as? Int
        place.accessibilityLevel = snap.value["accessibilityLevel"] as? Float
        place.WC_Access = snap.value["WC_Access"] as? Float
        place.types = snap.value["types"] as? [AnyObject]
        place.images = snap.value["images"] as? [AnyObject]
        place.comments = snap.value["comments"] as? [AnyObject]
        return place
    }
    
    class func PlaceFromGMSPlace(gmsPlace: GMSPlace) -> Place {
        let place = Place()
        place.ID = gmsPlace.placeID
        place.name = gmsPlace.name
        place.latitude = gmsPlace.coordinate.latitude
        place.longitude = gmsPlace.coordinate.longitude
        place.formattedAddress = gmsPlace.formattedAddress
        place.types = gmsPlace.types
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
        dict.setValue(self.sumOfAccessibilityVote, forKey: "sumOfAccessibilityVote")
        dict.setValue(self.sumOfWcVote, forKey: "sumOfWcVote")
        dict.setValue(self.accessibilityLevel, forKey: "accessibilityLevel")
        dict.setValue(self.WC_Access, forKey: "WC_Access")
        dict.setValue(self.types, forKey: "types")
        dict.setValue(self.images, forKey: "images")
        dict.setValue(self.comments, forKey: "comments")
        return dict
    }
}
