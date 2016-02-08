//
//  PlaceViewController.swift
//  Enabled
//
//  Created by Bianka on 2/5/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var accessibility: UILabel!
    @IBOutlet var WCAccess: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var infoView: UITextView!
    
    var place: Place!
    var imageList: [AnyObject]!
    var imageIndex: Int = 0
    var maxIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = place.name
        self.accessibility.text = String(format: "%.1f%%", place.accessibilityLevel)
        self.WCAccess.text = String(format: "%.1f%%", place.WC_Access)
        let infoString = "Address: \(place.formattedAddress)"
        infoView.text = infoString
        
        if(place.images == nil) {
            maxIndex = 0
        }
        else {
            maxIndex = place.images.count
        }
        loadImageList()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.imageView.addGestureRecognizer(swipeLeft)
        self.imageView.addGestureRecognizer(swipeRight)
    }
    
    func loadImageList() {
        if(maxIndex > 0) {
            for(var i = 0; i < self.maxIndex; i++) {
                var base64 = place.images[i] as! NSString
                //let replaced = base64.stringByReplacingOccurrencesOfString("data:image/png;base64,", withString: "")
                print(base64)
//                if let range = base64.rangeOfString("data:image/png;base64,", options: .AnchoredSearch)  {
//                    base64.removeRange(range)
//                }
                let decodedData = NSData(base64EncodedString: base64 as String, options: [])
                if let decodedImage = UIImage(data: decodedData!) {
                    self.imageList.append(decodedImage)
                }
            }
        }
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                imageIndex--
                if(imageIndex < 0) {
                    imageIndex = maxIndex
                }
                print("swiped right")
            case UISwipeGestureRecognizerDirection.Left:
                imageIndex++
                if imageIndex > maxIndex {
                    imageIndex = 0
                }
                print("swiped left")
            default:
                print("default")
            }
            self.imageView = imageList[imageIndex] as! UIImageView
            //set the image
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RateSegue" {
            let controller = segue.destinationViewController as! RatingViewController
            controller.ratingCard = RatingCard()
            controller.ratingCard.placeID = self.place.ID
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (toInterfaceOrientation.isLandscape) {
            UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.imageView.alpha = 0.0
                self.imageView.alpha = 0.0
                }, completion: nil)
        }
        else {
            UIView.animateWithDuration(0.4, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.imageView.alpha = 1.0
                self.imageView.alpha = 1.0
                }, completion: nil)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
