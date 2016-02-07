//
//  RatingViewController.swift
//  Enabled
//
//  Created by Bianka on 2/5/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

//3 = Very accessible
//2 = Somewhat accessible
//1 = Not very accessible
//0 = Not accessible

//2 - Yes
//1 - Hardly
//0 - No
class RatingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var accessPicker: UIPickerView!
    @IBOutlet weak var wcPicker: UIPickerView!
    @IBOutlet weak var nextBtn: UIButton!

    var accessPickerData: [String] = [String]()
    var wcPickerData: [String] = [String]()
    var accessPick: Int! = 0
    var WC_Pick: Int! = 0
    var ratingCard: RatingCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingCard = RatingCard()
        self.accessPicker.delegate = self
        self.accessPicker.dataSource = self
        self.wcPicker.delegate = self
        self.wcPicker.dataSource = self
        accessPickerData = ["Not accessible", "Not very accessible", "Somewhat accessible", "Very accessible"]
        wcPickerData = ["No", "Hardly", "Yes"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RatingStepOneSegue" {
            //let controller = segue.destinationViewController as! 
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0) {
            return accessPickerData.count
        }
        else {
            return wcPickerData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0) {
            return accessPickerData[row]
        }
        else {
            return wcPickerData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0) {
            accessPick = row
        }
        else {
            WC_Pick = row
        }
    }
}
