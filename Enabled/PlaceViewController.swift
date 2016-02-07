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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = place.name
        self.accessibility.text = String(format: "%.1f%%", place.accessibilityLevel)
        self.WCAccess.text = String(format: "%.1f%%", place.WC_Access)
        let infoString = "Address: \(place.formattedAddress)"
        infoView.text = infoString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ratePlace(sender: AnyObject) {
        
    }
    
    @IBAction func tappedOnImage(sender: AnyObject) {
        print("tapped on image")
    }
    
    @IBAction func slideOnImage(sender: AnyObject) {
        print("slide on image")
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
