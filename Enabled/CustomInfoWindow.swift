//
//  CustomInfoWindow.swift
//  CustomInfoWindow
//
//  Created by Malek T. on 12/13/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    @IBOutlet var overlay: UIImage!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var accessibilityLevel: UILabel!
    @IBOutlet var WCaccessLevel: UILabel!
    @IBOutlet var distance: UILabel!
    
    func handleTap(){
        print("tapped from class")
    }
        /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
