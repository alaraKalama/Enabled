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

class RatingStepTwoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    let picker = UIImagePickerController()
    var delegate: RatingStepTwoDelegate? = nil
    var FirebaseRef: FirebaseTasks!

    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var stepOneController: RatingViewController!
    var ratingCard: RatingCard!
    var comment: String!
    var pickedImage: UIImage!
    
    override func viewDidLoad() {
        print("step 2 viewDidLoad")
        picker.delegate = self
        if(ratingCard != nil) {
            if(ratingCard.comment != nil) {
                self.commentView.text = ratingCard.comment
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        FirebaseRef = FirebaseTasks.init()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("step 2 viewWillAppear")
        print(ratingCard)
        if(ratingCard != nil) {
            if(ratingCard.comment != nil) {
                self.commentView.text = ratingCard.comment
            }
            if(ratingCard.image != nil) {
                self.imageView.image = ratingCard.image
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("step 2 viewWillDisappear")
        ratingCard.comment = commentView.text
        ratingCard.image = pickedImage
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
    
    @IBAction func photoFromLibrary(sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true,
            completion: nil)
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker,
                animated: true,
                completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = pickedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true,
            completion: nil)
    }

    @IBAction func saveRatingToFirebase(sender: AnyObject) {
        if(commentView.text != nil){
            ratingCard.comment = commentView.text
        }
        if(imageView.image != nil){
            ratingCard.image = imageView.image
        }
        FirebaseRef.saveRatingToFirebase(self.ratingCard, listener: self)
    }
}
