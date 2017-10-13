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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listTable.reloadData()
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentStore.sharedInstance.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentLocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! LocationListCell
        
        let location = StudentStore.sharedInstance.locations[indexPath.row]
        
        cell.titleLabel?.text = location.userName
        cell.descriptionLabel?.text = location.media
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let location = StudentStore.sharedInstance.locations[indexPath.row]
        
        guard let url = URL(string:location.media) else {
            print("Unable to generate URL")
            return
        }
        
        print("Opening URL")
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension ListViewController: TabUIUpdates {
    func startUpdates(dataChanging: Bool) {
        listTable.isHidden = true
        loadingActivity.startAnimating()
    }
    
    func stopUpdates() {
        self.listTable.isHidden = false
        self.loadingActivity.stopAnimating()
    }
    
    func updateData() {
        self.listTable.reloadData()
    }
}
