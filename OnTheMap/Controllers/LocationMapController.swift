//
//  LocationMapController.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/12.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit
import MapKit

class LocationMapController: UIViewController {
    
    var coordinate: CLLocationCoordinate2D? = nil
    var locationText: String? = nil
    var mediaURL: String? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // MARK: UIViewController Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Started with Coordinate ",coordinate ?? "Unknown")
        print("Location: ",locationText ?? "Unknown"," Media: ",mediaURL ?? "Unknown")
        mapView.clearMapAnnotations()
        displayMapLocation()
    }
    
    @IBAction func finishPressed(_ sender: Any) {
        let newLocation: ParseStudentInformation = ParseStudentInformation(dictionary:[
            ParseClient.JSONResponseKeys.objectId:(ParseClient.sharedInstance().userLocation?.objectID as AnyObject),
            ParseClient.JSONResponseKeys.userId:UdacityClient.sharedInstance().userID as AnyObject,
            ParseClient.JSONResponseKeys.firstName:UdacityClient.sharedInstance().udacityUser?.userFirstName as AnyObject,
            ParseClient.JSONResponseKeys.lastName:UdacityClient.sharedInstance().udacityUser?.userLastName as AnyObject,
            ParseClient.JSONResponseKeys.mapString:self.locationText! as AnyObject,
            ParseClient.JSONResponseKeys.media:self.mediaURL! as AnyObject,
            ParseClient.JSONResponseKeys.latitude:(coordinate?.latitude)! as Double as AnyObject,
            ParseClient.JSONResponseKeys.longitude:(coordinate?.longitude)! as Double as AnyObject
            ])
        
        print("Got new location:",newLocation)
        
        mapView.alpha = 0.4
        activityView.startAnimating()
        
        ParseClient.sharedInstance().writeLocation(newLocation) { (success, error) in
            self.mapView.alpha = 1.0
            self.activityView.stopAnimating()
            if (success) {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Unable to post user location with error:\(error ?? "Unknown Error")", preferredStyle: UIAlertControllerStyle.alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Member functions
    
    func displayMapLocation() {
        if let coordinate = self.coordinate {
            var annotations = [MKPointAnnotation]()
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            let zoomRect = MKMapRectForCoordinateRegion(region: zoomRegion)
            print("Show Annotation at ",coordinate)
            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
            self.mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }
    
    func MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect {
        let a: MKMapPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
            region.center.latitude + region.span.latitudeDelta / 2,
            region.center.longitude - region.span.longitudeDelta / 2));
        let b: MKMapPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
            region.center.latitude - region.span.latitudeDelta / 2,
            region.center.longitude + region.span.longitudeDelta / 2));
        return MKMapRectMake(min(a.x,b.x), min(a.y,b.y), abs(a.x-b.x), abs(a.y-b.y));
    }
}

extension LocationMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
