//
//  StudentStore.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/13.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation

class StudentStore: NSObject {
    var locations: [ParseStudentInformation]
    var userLocation: ParseStudentInformation? = nil
    
    override init() {
        locations = [ParseStudentInformation]()
        super.init()
    }
    
    func clearList() {
        locations = [ParseStudentInformation]()
        userLocation = nil
    }
    
    static let sharedInstance = StudentStore()

//    class func sharedInstance() -> StudentStore {
//        struct Singleton {
//            static var sharedInstance = StudentStore()
//        }
//        return Singleton.sharedInstance
//    }
}
