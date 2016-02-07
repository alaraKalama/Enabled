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
            if(snap.value is NSNull){
                place.numberOfVoter = 0
                place.sumOfAccessibilityVote = 0
                place.sumOfWcVote = 0
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
    
    func saveRatingToFirebase(📊: RatingCard, listener: RatingStepTwoViewController) {
        let id = 📊.placeID
        let refPlace = places.childByAppendingPath(id)
        refPlace.observeSingleEventOfType(.Value, withBlock: {snap in
            let 📌 = Place.PlaceFromDataSnapshot(snap)
            //calculate accessibility %
            📌.numberOfVoter = 📌.numberOfVoter.successor()
            📌.sumOfAccessibilityVote = 📌.sumOfAccessibilityVote.advancedBy(📊.accessibilityRating!, limit: Int.max)
            📌.sumOfWcVote = 📌.sumOfWcVote.advancedBy(📊.WC_Rating!, limit: Int.max)
            📌.accessibilityLevel = self.findAverage(📌.sumOfAccessibilityVote, num: 📌.numberOfVoter)
            📌.WC_Access = self.findAverage(📌.sumOfWcVote, num: 📌.numberOfVoter)
            refPlace.setValue(📌.placeAsDictionaty())
            //print(📊.comment.isEmpty)
            
            print("is comment nil")
            print(📊.comment == nil)
            print("is comment empty")
            print(((📊.comment ?? "").isEmpty))
            if(!(📊.comment ?? "").isEmpty) {
                print("inside if")
                let refComments = refPlace.childByAppendingPath("Comments")
                refComments.childByAutoId().setValue(📊.comment)
            }
            print("is image nil")
            print(📊.image == nil)

            if(📊.image != nil) {
                let jpeg: NSData = UIImageJPEGRepresentation(📊.image, 0.3)!
                let base64String: String = jpeg.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
                let quoteString = ["base64": base64String]
                let refPhotos = refPlace.childByAppendingPath("Images")
                let refBase54 = refPhotos.childByAutoId()
                refBase54.setValue(quoteString)
            }
            
        })
    }
    
    func findAverage(sum: Int, num: Int) -> Float {
        return Float(sum)/Float(num)
    }
}
