//
//  StringExtensions.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/10.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidURL() -> Bool {
        guard let url = URL(string:self) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url as URL)
    }
    
}
