//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/11.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    // Mark: UIViewController Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.clearMapAnnotations()
        displayMapLocations()
    }
    
    // MARK: Member Functions
    
    func displayMapLocations() {
        var annotations = [MKPointAnnotation]()
        for location in StudentStore.sharedInstance.locations {
            let coordinate = location.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.userName
            annotation.subtitle = location.media
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView

    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //TODO: Consider URLs without http prefix
        
        guard control == annotationView.rightCalloutAccessoryView else {
            print("Incorrect calling control")
            return
        }
        
        let mediaURL: String = (annotationView.annotation?.subtitle!)!
        guard let url = URL(string:mediaURL) else {
            print("Unable to generate URL")
            return
        }
            
        print("Opening URL")
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension MapViewController: TabUIUpdates {
    func startUpdates(dataChanging: Bool) {
        print("Start updates in map:",dataChanging)
        if (dataChanging) {
            mapView.clearMapAnnotations()
        }
        self.mapView.alpha = 0.4
        self.loadingActivity.startAnimating()
    }
    
    func stopUpdates() {
        print("Stop updates in map")
        self.mapView.alpha = 1.0
        self.loadingActivity.stopAnimating()
    }
    
    func updateData() {
        displayMapLocations()
    }
}
