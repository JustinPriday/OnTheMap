//
//  ParseLocation.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/11.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation
import MapKit

struct ParseLocation {
    let objectID: String?
    let userID: String?
    let userFirstName: String
    let userLastName: String
    var userName: String {
        return "\(userFirstName) \(userLastName)"
    }
    let locationMapString: String
    let media: String
    let latitude: Float
    let longitude: Float
    var coordinate: CLLocationCoordinate2D {
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    var submitString: String {
        return "{\"\(ParseClient.JSONResponseKeys.userId)\": \"\(userID!)\", \"\(ParseClient.JSONResponseKeys.firstName)\": \"\(userFirstName)\", \"\(ParseClient.JSONResponseKeys.lastName)\": \"\(userLastName)\",\"\(ParseClient.JSONResponseKeys.mapString)\": \"\(locationMapString)\", \"\(ParseClient.JSONResponseKeys.media)\": \"\(media)\",\"\(ParseClient.JSONResponseKeys.latitude)\": \(latitude), \"\(ParseClient.JSONResponseKeys.longitude)\": \(longitude)}"
    }
    
    //I encountered some undocumented behaviour in the response for the call that uses this initialization. On occassion
    //results are in a "udacity" dictionary in the "results" dictionary. At time of writing this was coming in 2 of the
    //most recent 100 posts. Also "uniqueKey" not always supplied, accordingly userID optional and nilled when required.
    init(dictionary: [String:AnyObject]) {
        objectID = dictionary[ParseClient.JSONResponseKeys.objectId] as? String ?? nil
        if let udacitydictionary = dictionary["udacity"] as? [String:AnyObject] {
            userID = udacitydictionary[ParseClient.JSONResponseKeys.userId] as? String ?? nil
            userFirstName = udacitydictionary[ParseClient.JSONResponseKeys.firstName] as? String ?? ""
            userLastName = udacitydictionary[ParseClient.JSONResponseKeys.lastName] as? String ?? ""
            locationMapString = udacitydictionary[ParseClient.JSONResponseKeys.mapString] as? String ?? ""
            media = udacitydictionary[ParseClient.JSONResponseKeys.media] as? String ?? ""
            latitude = udacitydictionary[ParseClient.JSONResponseKeys.latitude] as? Float ?? 0
            longitude = udacitydictionary[ParseClient.JSONResponseKeys.longitude] as? Float ?? 0
        } else {
            userID = dictionary[ParseClient.JSONResponseKeys.userId] as? String ?? nil
            userFirstName = dictionary[ParseClient.JSONResponseKeys.firstName] as? String ?? ""
            userLastName = dictionary[ParseClient.JSONResponseKeys.lastName] as? String ?? ""
            locationMapString = dictionary[ParseClient.JSONResponseKeys.mapString] as? String ?? ""
            media = dictionary[ParseClient.JSONResponseKeys.media] as? String ?? ""
            latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Float ?? 0
            longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Float ?? 0
        }
    }
}

extension ParseLocation: Equatable {
    static func ==(lhs: ParseLocation, rhs: ParseLocation) -> Bool {
        return lhs.userID == rhs.userID
    }
}
