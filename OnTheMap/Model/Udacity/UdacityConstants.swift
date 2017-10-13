//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/10.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"

    }
    
    struct Methods {
        static let Session = "/session"
        static let User = "/users/"
    }
    
    struct JSONResponseKeys {
        static let account = "account"
        static let userID = "key"
        
        static let user = "user"
        static let userFirstName = "first_name"
        static let userLastName = "last_name"
    }
    
    struct ErrorMessage {
        static let networkError = "Unable to reach Udacity, please check your network."
        static let credentialError = "Invalid Email or Password"
        static let unknownError = "Unknown Error" //Should not be reachable, defensively included
    }
    
}
