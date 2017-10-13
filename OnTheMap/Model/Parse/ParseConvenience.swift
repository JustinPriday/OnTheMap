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
            ParameterKeys.limit:Constants.StudentCount as AnyObject,
            ParameterKeys.order:ParamterOptions.orderCreatedDesc as AnyObject]
        let _ = taskForGETMethod(Methods.Locations, parameters: parameters) { (results, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(false, ErrorMessage.networkError)
                }
            } else {
                if let results = results {
                    if let locationResults = results[JSONResponseKeys.results] as? [[String:AnyObject]] {
                        var userLocation: ParseStudentInformation? = nil
                        let userID = UdacityClient.sharedInstance().userID
                        var locations = [ParseStudentInformation]()
                        for studentLocationDict in locationResults {
                            let studentLocation: ParseStudentInformation = ParseStudentInformation(dictionary: studentLocationDict)
                            //Users location always first.
                            if studentLocation.userID == userID {
                                locations.insert(studentLocation, at: 0)
                                userLocation = studentLocation
                            } else {
                                locations.append(studentLocation)
                            }
                        }
                        if (userLocation != nil) {
                            //We have a student location for the current user, no need to request.
                            StudentStore.sharedInstance().locations = locations
                            StudentStore.sharedInstance().userLocation = userLocation
                            DispatchQueue.main.async {
                                completionHandler(true, nil)
                            }
                        } else {
                            self.requestLocationForStudent(userID!, completionHandler: { (success, location, error) in
                                if success, let location = location {
                                    userLocation = location
                                    //Users location always first
                                    locations.insert(location, at:0)
                                    StudentStore.sharedInstance().locations = locations
                                    StudentStore.sharedInstance().userLocation = userLocation
                                } else {
                                    StudentStore.sharedInstance().locations = locations
                                    StudentStore.sharedInstance().userLocation = nil
                                }
                                DispatchQueue.main.async {
                                    completionHandler(true, nil)
                                }
                            })
                        }

                    } else {
                        DispatchQueue.main.async {
                            completionHandler(false, ErrorMessage.invalidResponse)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false, ErrorMessage.invalidResponse)
                    }
                }
            }
        }
    }
    
    func requestLocationForStudent(_ studentID: String, completionHandler: @escaping (_ success: Bool, _ location: ParseStudentInformation?, _ error: String?) -> Void) {
        let parameters : [String:AnyObject] = [
            ParameterKeys.studentWhere:"{\"\(ParameterKeys.userID)\":\"\(studentID)\"" as AnyObject]
        let _ = taskForGETMethod(Methods.Locations, parameters: parameters) { (results, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(false, nil, ErrorMessage.networkError)
                }
            } else {
                if let results = results, let userResult = results[JSONResponseKeys.results] as? [String:AnyObject] {
                    let location: ParseStudentInformation = ParseStudentInformation(dictionary: userResult)
                    completionHandler(true, location, nil)
                } else {
                    completionHandler(false, nil, ErrorMessage.invalidResponse)
                }
            }
        }
    }
    
    func writeLocation(_ location: ParseStudentInformation, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var httpMethod: String? = nil
        var apiMethod: String? = nil
        
        if let objectID = location.objectID {
            //replace current object
            httpMethod = "PUT"
            apiMethod = "\(Methods.PUTLocation)\(objectID)"
        } else {
            //create a new object
            httpMethod = "POST"
            apiMethod = Methods.Locations
        }
        
        print("Sending results:",location.submitString)
        let _ = taskForPUTPOSTMethod(apiMethod!, parameters: [:], httpMethod: httpMethod!, jsonBody: location.submitString) { (results, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(false, ErrorMessage.networkError)
                }
            } else {
                if let results = results {
                    print("Location save results:",results)
                    if let error = results[ParseClient.JSONResponseKeys.error] as? String {
                        completionHandler(false, error)
                        return
                    }
                    DispatchQueue.main.async {
                        completionHandler(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false, ErrorMessage.invalidResponse)
                    }
                }
            }
        }
    }
    
    func deleteLocation(withID: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let httpMethod = "DELETE"
        let apiMethod = "\(Methods.PUTLocation)\(withID)"
        let _ = taskForPUTPOSTMethod(apiMethod, parameters: [:], httpMethod: httpMethod, jsonBody: nil) { (results, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(false, ErrorMessage.networkError)
                }
            } else {
                if let results = results {
                    print("Location save results:",results)
                    DispatchQueue.main.async {
                        completionHandler(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false, ErrorMessage.invalidResponse)
                    }
                }
            }
        }
    }
}
