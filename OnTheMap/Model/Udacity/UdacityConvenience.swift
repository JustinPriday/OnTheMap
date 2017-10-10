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
        print("Request auth for \(username):\(password)")
        completionHandler(true, nil)
    }
    
    private func getSessionID() {
        
    }
    
}
