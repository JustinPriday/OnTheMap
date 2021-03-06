//
//  LocationCaptureController.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/12.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit
import MapKit

class LocationCaptureController: UIViewController {

    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var findButton: UIRoundedButton!
    @IBOutlet weak var activityVIew: UIActivityIndicatorView!
    
    var coordinate: CLLocationCoordinate2D? = nil
    
    // MARK: UIViewController Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBOutlets
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func findPressed(_ sender: Any) {
        guard let locationText = locationText.text, !locationText.isEmpty else {
            showError(title: "Location Not Found", message: "Must Enter a Location")
            return
        }
        
        guard let siteText = websiteText.text, siteText.isValidURL() else {
            showError(title: "Website Required", message: "Must Enter a Website. Include HTTP(S)://")
            return
        }

        self.enableUI(false)
        let geoCoder = CLGeocoder()
        print("Starting Geocode on ",locationText)
        geoCoder.geocodeAddressString(locationText) { (placeMarks, error) in
            self.enableUI(true)
            guard
                let placeMarks = placeMarks,
                let location = placeMarks.first?.location
                else {
                self.showError(title: "Location Not Found", message: "Try Another Location Search")
                return
            }
            print("Got Location ",location)
            self.coordinate = location.coordinate
            self.performSegue(withIdentifier: "FindOnMap", sender: nil)
        }
    }
    
    // MARK: Member Functions
    
    func enableUI(_ enabled: Bool) {
        locationText.isEnabled = enabled
        websiteText.isEnabled = enabled
        findButton.isEnabled = enabled
        if enabled {
            activityVIew.stopAnimating()
        } else {
            activityVIew.startAnimating()
        }
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "FindOnMap") {
            if let _ = self.coordinate {
                return true
            }
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FindOnMap") {
            let destination = segue.destination as? LocationMapController
            destination?.coordinate = self.coordinate
            destination?.locationText = self.locationText.text
            destination?.mediaURL = self.websiteText.text
        }
    }

}
