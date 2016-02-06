//
//  FirebaseAdapter.swift
//  Enabled
//
//  Created by Bianka on 2/6/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit
import Firebase

class FirebaseAdapter: NSObject {

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
    
    func placeExistsInFirebase(id: String) -> Bool {
        var exists = false
        places.childByAppendingPath(id).observeSingleEventOfType(.Value, withBlock: {snap in
            if(snap == nil){
                exists = false
            }
            else {
                exists = true
            }
        })
        return exists
    }
}
