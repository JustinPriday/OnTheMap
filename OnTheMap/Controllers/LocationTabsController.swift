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
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshedPressed(_ sender: Any) {
        print("Refresh")
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
                print("Student list failed with error: ",error!)
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
    
    // MARK: Member functions
    
    func addMapLocation() {
        self.performSegue(withIdentifier: "ShowAddLocation", sender: nil)
    }
    
    func enableButtons(_ enabled: Bool) {
        logoutButton.isEnabled = enabled
        refreshButton.isEnabled = enabled
        addButton.isEnabled = enabled
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
