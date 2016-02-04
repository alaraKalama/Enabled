//
//  ViewController.swift
//  Enabled
//
//  Created by Bianka on 2/2/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//
import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, GMSMapViewDelegate, LocateOnTheMap {
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    
    @IBOutlet weak var lblInfo: UILabel!
   
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var placePicker: GMSPlacePicker!
    var latitude: Double!
    var longitude: Double!
    var locationMarker: GMSMarker!
    var infoWindow = CustomInfoWindow()
    var searchResultController:SearchResultController!
    var resultsArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        locationManager.delegate = self
        //ask for permission to access current location
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewMap.animateToZoom(25.0)
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New , context: nil)
        searchResultController = SearchResultController()
        searchResultController.delegate = self
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 18.0)
            viewMap.delegate = self
            self.latitude = myLocation.coordinate.latitude
            self.longitude = myLocation.coordinate.longitude
            viewMap.settings.myLocationButton = true
            didFindMyLocation = true
        }
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        viewMap.clear()
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.icon = UIImage(named: "pin")
        locationMarker.infoWindowAnchor = CGPointMake(0.3, 0.2)
        locationMarker.map = viewMap
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.myLocationEnabled = true
            viewMap.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("An error occurred while tracking location changes : \(error.description)")
    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 18.0)
            self.viewMap.camera = camera
            marker.icon = UIImage(named: "pin")
            marker.snippet = "Accessibility: 10%\nWC access: NO"
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
    
    //allow the app to use the custom info window
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        self.infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil)[0] as! CustomInfoWindow
        self.infoWindow.placeName.text = "Text Name"
        self.infoWindow.accessibilityLevel.text = "100%"
        self.infoWindow.WCaccessLevel.text = "NO"
        self.infoWindow.userInteractionEnabled = true
        return self.infoWindow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDistanceMetresBetweenLocationCoordinates(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distanceFromLocation(location2)
    }

    // action methods
    
    func didLongPressInfoWindowOfMarker(marker: GMSMarker) {
        print("Long press info window")
    }
    
    @IBAction func searchNearbyPlaces(sender: AnyObject) {
        print("Search")
        let position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let northEast = CLLocationCoordinate2DMake(position.latitude + 0.001, position.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(position.latitude - 0.001, position.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        self.placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlaceWithCallback{(place: GMSPlace?, error: NSError?) ->
            Void in
            if let error = error {
                print("Error occured: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                let marker = GMSMarker(position: coordinates)
                marker.title = place.name
                marker.icon = UIImage(named: "pin")
                marker.map = self.viewMap
                //TODO: Add a picked place to Firebase
                self.viewMap.animateToLocation(coordinates)
                self.viewMap.animateToZoom(18.0)
            }
            else {
                print("No place was selected")
            }
        }
    }
    
    @IBAction func findAddress(sender: AnyObject) {
        print("find")
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        //TODO: Add a picked place to Firebase
        self.presentViewController(searchController, animated: true, completion: nil)
    }
}