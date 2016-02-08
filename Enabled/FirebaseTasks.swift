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
        root = Firebase(url: "https://onwheels.firebaseio.com/")
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
            
            //comment
            if(!(📊.comment ?? "").isEmpty) {
                if(📌.comments == nil) {
                    📌.comments = []
                }
                📌.comments.append(📊.comment)
            }
            
            //image
            if(📊.image != nil) {
                let imageResized = self.resizeImage(📊.image, targetSize: CGSizeMake(200.0, 200.0))
                let data: NSData = UIImagePNGRepresentation(imageResized)!
                let base64String: NSString = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                if(📌.images == nil) {
                    📌.images = []
                }
                📌.images.append(base64String)
            }
            
            refPlace.setValue(📌.placeAsDictionaty(), withCompletionBlock: {
                (error:NSError?, ref:Firebase!) in
                if (error == nil) {
                    listener.successfulSave()
                } else {
                    print(error?.code)
                }
            })
        })
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func findAverage(sum: Int, num: Int) -> Float {
        return Float(sum)/Float(num)
    }
}
