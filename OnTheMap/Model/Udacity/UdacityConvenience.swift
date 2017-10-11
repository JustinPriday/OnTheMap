//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/10.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation

extension UdacityClient {
        
    func authenticateUdacity(username: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        getUserID(username: username, password: password) { (success, userID, error) in
            if success, let userID = userID {
                self.userID = userID
                self.getUser(id: userID, completionHandlerUser: { (success, user) in
                    if success, let user = user {
                        self.udacityUser = user
                        DispatchQueue.main.async {
                            completionHandler(true, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler(false,ErrorMessage.unknownError) //success but no user, fail case
                        }
                    }
                })
            } else {
                if let error = error {
                    DispatchQueue.main.async {
                        completionHandler(false,error)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false,ErrorMessage.unknownError)
                    }
                }
            }
        }
    }
    
    private func getUserID(username: String, password: String, completionHandlerSession: @escaping (_ success: Bool, _ userID: String?, _ error: String?) -> Void) {
        let parameters : [String:AnyObject] = [:]
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            if let _ = error {
                completionHandlerSession(false, nil, ErrorMessage.networkError)
            } else {
                if let results = results {
                    if let account = results[JSONResponseKeys.account] as? NSDictionary {
                        if let userID = account[JSONResponseKeys.userID] as? String {
                            completionHandlerSession(true, userID, nil)
                        } else {
                            completionHandlerSession(false, nil, ErrorMessage.credentialError)
                        }
                    } else {
                        completionHandlerSession(false, nil, ErrorMessage.credentialError)
                    }
                    
                } else {
                    completionHandlerSession(false, nil, ErrorMessage.networkError)
                }
            }
        }
    }
    
    private func getUser(id: String, completionHandlerUser: @escaping (_ success: Bool, _ user: UdacityUser?) -> Void) {
        let parameters : [String:AnyObject] = [:]
        let method = Methods.User + id
        
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            if let _ = error {
                completionHandlerUser(false, nil)
            } else {
                if let results = results {
                    if let userDict = results[JSONResponseKeys.user] as? [String:AnyObject] {
                        let user = UdacityUser(dictionary: userDict)
                        completionHandlerUser(true, user)
                    }
                } else {
                    completionHandlerUser(false, nil)
                }
            }
        }
    }
    
}
