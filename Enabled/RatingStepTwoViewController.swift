//
//  RatingStepTwoViewController.swift
//  Enabled
//
//  Created by Bianka on 2/7/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

class RatingStepTwoViewController: UIViewController {
   
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var ratingCard: RatingCard!
    
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
