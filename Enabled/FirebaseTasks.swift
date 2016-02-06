//
//  FirebaseAdapter.swift
//  Enabled
//
//  Created by Bianka on 2/6/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit
import Firebase

class FirebaseTasks: NSObject {

    var root: Firebase!
    var places: Firebase!
    
    
    override init() {
        root = Firebase(url: "https://enabled-moga-sam.firebaseio.com/")
        places = root.childByAppendingPath("Places")
    }
    
    func savePlaceToFirebase(place: Place) {
        let placeDict = place.placeAsDictionaty()
        let placeRef = self.places.childByAppendingPath(place.ID)
        placeRef.setValue(placeDict)
    }
    
    func placeExistsInFirebase(place: Place, listener: MapViewController) {
        let refPlace = places.childByAppendingPath(place.ID)
        refPlace.observeSingleEventOfType(.Value, withBlock: {snap in
            print(snap)
            if(snap.value is NSNull){
                place.numberOfVoter = 0
                place.accessibilityLevel = 0
                place.WC_Access = 0
                self.savePlaceToFirebase(place)
                listener.currentPlacePicked = place
            }
            else {
                listener.currentPlacePicked = Place.PlaceFromDataSnapshot(snap)
            }
        })
    }
}
