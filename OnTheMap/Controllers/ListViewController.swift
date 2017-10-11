//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/11.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    // MARK: UIViewController Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateList()
    }
    
    // MARK: IBActions
    
    @IBAction func logoutPressed(_ sender: Any) {
    }
    
    @IBAction func refreshLocationsPressed(_ sender: Any) {
        updateList()
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
    }
    //MARK: Private Functions
    
    private func updateList() {
        ParseClient.sharedInstance().clearList()
        
        listTable.isHidden = true
        loadingActivity.startAnimating()
        
        ParseClient.sharedInstance().requestStudentLocations { (success, error) in
            self.loadingActivity.stopAnimating()
            self.listTable.isHidden = false
            guard success, error == nil else {
                print("Student list failed with error: ",error!)
                return
            }
            self.listTable.reloadData()
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentLocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! LocationListCell
        
        let location = ParseClient.sharedInstance().locations[indexPath.row]
        
        cell.titleLabel?.text = location.userName
        cell.descriptionLabel?.text = location.media
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let location = ParseClient.sharedInstance().locations[indexPath.row]
        
        guard let url = URL(string:location.media) else {
            print("Unable to generate URL")
            return
        }
        
        print("Opening URL")
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
