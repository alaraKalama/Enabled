//
//  RatingStepTwoViewController.swift
//  Enabled
//
//  Created by Bianka on 2/7/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

protocol RatingStepTwoDelegate {
    func ControllerDidFinish(controller: RatingStepTwoViewController, ratingCard: RatingCard)
}

class RatingStepTwoViewController: UIViewController {
   
    var delegate: RatingStepTwoDelegate? = nil
    
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var stepOneController: RatingViewController!
    var ratingCard: RatingCard!
    var comment: String!
    var imageBase64: String!
    
    override func viewDidLoad() {
        print("step 2 viewDidLoad")
        if(ratingCard != nil) {
            if(ratingCard.comment != nil) {
                self.commentView.text = ratingCard.comment
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print("step 2 viewWillAppear")
        print(ratingCard)
        if(ratingCard != nil) {
            if(ratingCard.comment != nil) {
                self.commentView.text = ratingCard.comment
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("step 2 viewWillDisappear")
        ratingCard.comment = commentView.text
        print(ratingCard)
        if(delegate != nil) {
            delegate!.ControllerDidFinish(self, ratingCard: self.ratingCard)
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (toInterfaceOrientation.isLandscape) {
            UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.imageView.alpha = 0.0
                }, completion: nil)
        }
        else {
            UIView.animateWithDuration(0.4, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.imageView.alpha = 1.0
                }, completion: nil)
        }
        
    }

}
