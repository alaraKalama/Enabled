//
//  ViewController.swift
//  Enabled
//
//  Created by Bianka on 2/2/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    
    @IBOutlet weak var lblInfo: UILabel!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var locationMarker: GMSMarker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        //ask for permission to access current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New , context: nil)

        // displaying the map content
        //let 📷: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        //viewMap.camera = 📷
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = viewMap
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            viewMap.myLocationEnabled = true
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 15.0)
            viewMap.settings.myLocationButton = true
            didFindMyLocation = true
        }
    }
    
    // MARK: IBAction method implementation
    
    @IBAction func searchNearbyPlaces(sender: AnyObject) {
        
    }
    
    
    @IBAction func findAddress(sender: AnyObject) {
        
    }
    
    
    @IBAction func addPlace(sender: AnyObject) {
        
    }
    
}

