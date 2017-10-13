//
//  LocationTabsController.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/12.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit

class LocationTabsController: UITabBarController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshedPressed(self)
    }

    // MARK: IBActions
    
    @IBAction func logoutPressed(_ sender: Any) {
        print("Logout")
        enableButtons(false)
        if let topView = self.selectedViewController as? TabUIUpdates {
            topView.startUpdates(dataChanging: false)
        }
        UdacityClient.sharedInstance().logout { (success, error) in
            self.enableButtons(true)
            if let topView = self.selectedViewController as? TabUIUpdates {
                topView.stopUpdates()
            }
            if success == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showErrorAlert(error ?? "Unknown Error")
            }
        }
    }
    
    @IBAction func refreshedPressed(_ sender: Any) {
        enableButtons(false)
        if let topView = self.selectedViewController as? TabUIUpdates {
            topView.startUpdates(dataChanging: true)
        }
        ParseClient.sharedInstance().requestStudentLocations { (success, error) in
            self.enableButtons(true)
            if let topView = self.selectedViewController as? TabUIUpdates {
                topView.stopUpdates()
            }
            guard success, error == nil else {
                self.showErrorAlert("Student list download failed with error:\(error ?? "Unknown Error")")
                return
            }
            if let topView = self.selectedViewController as? TabUIUpdates {
                topView.updateData()
            }
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        if (ParseClient.sharedInstance().userLocation != nil) {
            let confirmString = "User \"\(UdacityClient.sharedInstance().udacityUser?.userFullName ?? "")\" Has Already Posted a Student Location. Would You Like To Overwrite Their Location?"
            let alert = UIAlertController(title: "", message: confirmString, preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "Overwrite", style: .default) { (action) in
                self.addMapLocation()
            }
            let dismissAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            alert.addAction(confirmAction)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            addMapLocation()
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let confirmString = "User \"\(UdacityClient.sharedInstance().udacityUser?.userFullName ?? "")\" Has a Posted Student Location. Would You Like To Delete Their Location?"
        let alert = UIAlertController(title: "Delete Location?", message: confirmString, preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteUserLocation()        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(confirmAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: Member functions
    
    func addMapLocation() {
        self.performSegue(withIdentifier: "ShowAddLocation", sender: nil)
    }
    
    func deleteUserLocation() {
        //Unrequired addition, probably not in the best UI position. This was added to allow testing of the POST method of setting
        //a location. The DELETE call supplying the locations objectID was undocumented to my knowledge but works as expected.
        enableButtons(false)
        if let topView = self.selectedViewController as? TabUIUpdates {
            topView.startUpdates(dataChanging: true)
        }
        if let userLocationID = ParseClient.sharedInstance().userLocation?.objectID {
            ParseClient.sharedInstance().deleteLocation(withID: userLocationID, completionHandler: { (success, error) in
                print("Got Delete Result")
                
                ParseClient.sharedInstance().requestStudentLocations { (success, error) in
                    self.enableButtons(true)
                    if let topView = self.selectedViewController as? TabUIUpdates {
                        topView.stopUpdates()
                    }
                    guard success, error == nil else {
                        print("Student list failed with error: ",error!)
                        return
                    }
                    if let topView = self.selectedViewController as? TabUIUpdates {
                        topView.updateData()
                    }
                }
            })
        }
    }
    
    func showErrorAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func enableButtons(_ enabled: Bool) {
        logoutButton.isEnabled = enabled
        refreshButton.isEnabled = enabled
        addButton.isEnabled = enabled
        if let _ = ParseClient.sharedInstance().userLocation {
            deleteButton.isEnabled = enabled
        } else {
            deleteButton.isEnabled = false;
        }
        if let items = tabBar.items {
            for item: UITabBarItem in items {
                item.isEnabled = enabled
            }
        }
    }
}

protocol TabUIUpdates {
    func startUpdates(dataChanging: Bool)
    func stopUpdates()
    func updateData()
}
