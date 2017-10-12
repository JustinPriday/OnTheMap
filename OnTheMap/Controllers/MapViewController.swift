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

        updateMapLocations()
    }
    
    // MARK: IBActions
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.mapView.alpha = 0.4
        self.loadingActivity.startAnimating()
        UdacityClient.sharedInstance().logout { (success, error) in
            self.mapView.alpha = 1.0
            self.loadingActivity.stopAnimating()
            if success == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshLocationsPressed(_ sender: Any) {
        updateMapLocations()
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
    }
    
    // MARK: Private Functions
    
    func updateMapLocations() {
        self.mapView.alpha = 0.4
        self.loadingActivity.startAnimating()
        self.clearMapAnnotations()

        ParseClient.sharedInstance().requestStudentLocations { (success, error) in
            self.mapView.alpha = 1.0
            self.loadingActivity.stopAnimating()
            guard success, error == nil else {
                print("Student list failed with error: ",error!)
                return
            }
            
            var annotations = [MKPointAnnotation]()
            for location in ParseClient.sharedInstance().locations {
                let coordinate = location.coordinate
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.userName
                annotation.subtitle = location.media
                
                annotations.append(annotation)
            }
            
            self.mapView.addAnnotations(annotations)
        }
    }
    
    private func clearMapAnnotations() {
        let annotations = self.mapView.annotations
        for annotation in annotations {
            self.mapView.removeAnnotation(annotation)
        }
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
