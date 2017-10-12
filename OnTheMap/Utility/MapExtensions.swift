//
//  MapExtensions.swift
//  OnTheMap
//
//  Created by Justin Priday on 2017/10/12.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func clearMapAnnotations() {
        let annotations = self.annotations
        for annotation in annotations {
            self.removeAnnotation(annotation)
        }
    }
}
