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
import Firebase

//navigate to another view
/*
dispatch_async(dispatch_get_main_queue(), { () -> Void in
let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
self.presentViewController(viewController, animated: true, completion: nil)
})
*/

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, GMSMapViewDelegate, LocateOnTheMap {
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let Server_API_Key = "AIzaSyAw6LWaEEer7HnOElj04hShipbibHzCtQM"

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var infoWindow: CustomInfoWindow!

    var FirebaseRef: FirebaseAdapter!
    var speech: SpeechTask!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var currentPlacePicked: GMSPlace!
    var placePicker: GMSPlacePicker!
    var latitude: Double!
    var longitude: Double!
    var locationMarker: GMSMarker!
    var searchResultController:SearchResultController!
    var resultsArray = [String]()
    var firstX:Double = 0;
    var firstY:Double = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        locationManager.delegate = self
        //ask for permission to access current location
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //gesture recognizer code
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self.infoWindow, action: "tapResponder")
        self.tapGestureRecognizer.numberOfTapsRequired = 1
        self.tapGestureRecognizer.numberOfTouchesRequired = 1

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseRef = FirebaseAdapter.init()
        viewMap.animateToZoom(13.0)
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New , context: nil)
        searchResultController = SearchResultController()
        searchResultController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        //Your app should be a good citizen of battery life and memory. To preserve battery life and memory usage, you should only synchronize data when the view is visible.
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Remove listeners in viewDidDisappear with a FirebaseHandle
        //If your controller is still syncing data when the view has disappeared, you are wasting bandwidth and memory.
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 13.0)
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
            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 13.0)
            self.viewMap.camera = camera
            marker.icon = UIImage(named: "pin")
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
        let place = getPlaceFromMarker(marker)
        //check place in firebase
        //update place info
        self.infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil)[0] as! CustomInfoWindow
        self.infoWindow.placeName.text = marker.title
        self.infoWindow.userInteractionEnabled = true
        self.tapGestureRecognizer.delegate = self.infoWindow
        self.infoWindow.addGestureRecognizer(self.tapGestureRecognizer)
        //TODO: method to generate this string
        let strText = "\(place.name) is 250 metres from here. Accessibility is 40% and the restroom access is 90%"
        self.speech = SpeechTask.init(text: strText)
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
    
    func getPlaceFromMarker(marker: GMSMarker) -> Place {
        let place = Place()
        let coordinates = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude)
        print(currentPlacePicked)
        //
        let url = NSURL(string: "\(baseUrl)latlng=\(coordinates.latitude),\(coordinates.longitude)&key=\(Server_API_Key)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        //print(json)
        if let result = json["results"] as? NSArray {
            if let address = result[0]["address_components"] as? NSArray {
                place.ID = currentPlacePicked.placeID
                place.types = currentPlacePicked.types
                place.name = currentPlacePicked.name
                place.latitude = marker.position.latitude
                place.longitude = marker.position.longitude
                place.strNumber = address[0]["short_name"] as! String
                place.street = address[1]["short_name"] as! String
                place.city = address[2]["short_name"] as! String
                place.country = address[address.count-2]["long_name"] as! String
                FirebaseRef.savePlaceToFirebase(place)
            }
        }
        return place
    }

    // action methods
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let placeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlaceViewController") as! PlaceViewController
        self.navigationController?.pushViewController(placeViewController, animated: true)
    }
    
    func mapView(mapView: GMSMapView!, didLongPressInfoWindowOfMarker marker: GMSMarker!) {
        self.speech.speak()
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
                self.viewMap.clear()
                self.currentPlacePicked = place
                let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                let marker = GMSMarker(position: coordinates)
                marker.title = place.name
                marker.icon = UIImage(named: "pin")
                marker.map = self.viewMap
                //TODO: Add a picked place to Firebase
                self.viewMap.animateToLocation(coordinates)
                self.viewMap.animateToZoom(13.0)
            }
            else {
                print("No place was selected")
            }
        }
    }
}