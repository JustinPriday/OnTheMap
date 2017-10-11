//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/11.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func requestStudentLocations(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let parameters : [String:AnyObject] = [
            ParameterKeys.limit:Constants.StudentCount as AnyObject]
        let _ = taskForGETMethod(Methods.Locations, parameters: parameters) { (results, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(false, "Network Error")
                }
            } else {
                if let results = results {
                    if let locationResults = results[JSONResponseKeys.results] as? [[String:AnyObject]] {
                        var locations = [ParseLocation]()
                        for userLocation in locationResults {
                            locations.append(ParseLocation(dictionary: userLocation))
                        }
                        self.locations = locations
                        DispatchQueue.main.async {
                            completionHandler(true, nil)
                        }

                    } else {
                        DispatchQueue.main.async {
                            completionHandler(false, "Could not parse results")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false, "success but no results")
                    }
                }
            }
        }
    }
}
