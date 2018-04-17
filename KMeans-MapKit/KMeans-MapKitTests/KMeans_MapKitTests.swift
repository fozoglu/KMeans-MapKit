//
//  KMeans_MapKitTests.swift
//  KMeans-MapKitTests
//
//  Created by CBS MOBIL on 4.04.2018.
//  Copyright © 2018 fozoglu. All rights reserved.
//

import XCTest
import MapKit
@testable import KMeans_MapKit

class KMeans_MapKitTests: XCTestCase {
    
    var viewControllerUnderTest : ViewController!
    
    override func setUp() {
        super.setUp()
       
    }
    
    override func tearDown() {
        super.tearDown()
        
        
    }
    
    func testAnnotationsCount() {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController else{
            XCTFail("Could not instatiate VC from Main Storyboard")
            return
        }
        vc.loadViewIfNeeded()
        guard let mapView = vc.mapView else {
            XCTFail("ViewController should have outlet set for mapView")
            return
        }
        XCTAssertEqual(mapView.annotations.count, 0, "Maps has not annotations.")
        
    }
    
    func testMapInitialization() {
        XCTAssert(viewControllerUnderTest.mapView.mapType == MKMapType.standard);
    }
    
    
}
