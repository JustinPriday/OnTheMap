//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/11.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation

struct UdacityUser {
    
    let userID: String
    let userFirstName: String
    let userLastName: String
    var userFullName: String {
        return "\(userFirstName) \(userLastName)"
    }
    
    init(dictionary: [String: AnyObject]) {
        if let tUserID = dictionary[UdacityClient.JSONResponseKeys.userID] as? String,
            let tUserFirstName = dictionary[UdacityClient.JSONResponseKeys.userFirstName] as? String,
            let tUserLastName = dictionary[UdacityClient.JSONResponseKeys.userLastName] as? String {
            userID = tUserID
            userFirstName = tUserFirstName
            userLastName = tUserLastName
       } else {
            userID = ""
            userFirstName = ""
            userLastName = ""
       }
    }
}

extension UdacityUser: CustomStringConvertible {
    var description: String {
        return "\(userID): \(userFirstName) \(userLastName)"
    }
}
