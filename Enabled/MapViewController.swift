//
//  ViewController.swift
//  Enabled
//
//  Created by Bianka on 2/2/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, LocateOnTheMap {
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    
    @IBOutlet weak var lblInfo: UILabel!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var locationMarker: GMSMarker!
    var searchResultController:SearchResultController!
    var resultsArray = [String]()
    
    
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
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 16.0)
            viewMap.settings.myLocationButton = true
            didFindMyLocation = true
        }
    }
    
    //autocomplete
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchResultController = SearchResultController()
        searchResultController.delegate = self
    }
    
    // MARK: IBAction method implementation
    
    @IBAction func searchNearbyPlaces(sender: AnyObject) {
        print("Search")
    }
    
    @IBAction func findAddress(sender: AnyObject) {
        print("find")
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    @IBAction func addPlace(sender: AnyObject) {
        print("add")

    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            self.viewMap.camera = camera
            
            marker.title = title
            marker.map = self.viewMap
        }
    }
    
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String){
            
            let placesClient = GMSPlacesClient()
            placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
                self.resultsArray.removeAll()
                if results == nil {
                    return
                }
                for result in results!{
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultsArray.append(result.attributedFullText.string)
                    }
                }
                self.searchResultController.reloadDataWithArray(self.resultsArray)
            }
    }
}