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
        places.childByAppendingPath(place.ID).observeSingleEventOfType(.Value, withBlock: {snap in
            if(snap == nil){
                self.savePlaceToFirebase(place)
            }
            else {
            }
        })
    }
}
