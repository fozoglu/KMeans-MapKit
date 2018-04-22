//
//  LocationAnnotation.swift
//  KMeans-MapKit
//
//  Created by Furkan Ozoglu on 4.04.2018.
//  Copyright © 2018 fozoglu. All rights reserved.
//


import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    var identifier: String?
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var color: MKPinAnnotationColor?
    
    init(identifier: String, title : String, subtitle: String, coordinate : CLLocationCoordinate2D) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init(identifier: String, title : String, coordinate : CLLocationCoordinate2D) {
        self.identifier = identifier
        self.title = title
        self.subtitle = nil
        self.coordinate = coordinate
    }
    
    
}
