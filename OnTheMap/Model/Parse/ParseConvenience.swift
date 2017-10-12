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
                        var userLocation: ParseLocation? = nil
                        let userID = UdacityClient.sharedInstance().userID
                        var locations = [ParseLocation]()
                        for studentLocationDict in locationResults {
                            let studentLocation: ParseLocation = ParseLocation(dictionary: studentLocationDict)
                            locations.append(studentLocation)
                            if studentLocation.userID == userID {
                                userLocation = studentLocation
                            }
                        }
                        if (userLocation != nil) {
                            //We have a student location for the current user, no need to request.
                            self.locations = locations
                            self.userLocation = userLocation
                            DispatchQueue.main.async {
                                completionHandler(true, nil)
                            }
                        } else {
                            self.requestLocationForStudent(userID!, completionHandler: { (success, location, error) in
                                if success, let location = location {
                                    userLocation = location
                                    locations.append(location)
                                    self.locations = locations
                                    self.userLocation = userLocation
                                } else {
                                    self.locations = locations
                                }
                                DispatchQueue.main.async {
                                    completionHandler(true, nil)
                                }
                            })
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
    
    func requestLocationForStudent(_ studentID: String, completionHandler: @escaping (_ success: Bool, _ location: ParseLocation?, _ error: String?) -> Void) {
        let parameters : [String:AnyObject] = [
            ParameterKeys.studentWhere:"{\"\(ParameterKeys.userID)\":\"\(studentID)\"" as AnyObject]
        let _ = taskForGETMethod(Methods.Locations, parameters: parameters) { (results, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(false, nil, "Network Error")
                }
            } else {
                if let results = results, let userResult = results[JSONResponseKeys.results] as? [String:AnyObject] {
                    let location: ParseLocation = ParseLocation(dictionary: userResult)
                    completionHandler(true, location, nil)
                } else {
                    completionHandler(false, nil, "success but no results")
                }
            }
        }
    }
}
