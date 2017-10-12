//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/11.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation

extension ParseClient {
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        static let StudentCount = 100
    }
    
    struct Methods {
        static let Locations = "/StudentLocation"
        static let PUTLocation = "/StudentLocation/"
    }
    
    struct ParameterKeys {
        static let studentWhere = "where"
        static let userID = "uniqueKey"
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
    }
    
    struct JSONResponseKeys {
        static let results = "results"
        
        static let objectId = "objectId"
        static let userId = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let media = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        
        static let error = "error"
    }
}
