//
//  ViewController.swift
//  KMeans-MapKit
//
//  Created by CBS MOBIL on 4.04.2018.
//  Copyright © 2018 fozoglu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var clusteringNumberButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var calculateKMeansButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var pin : LocationAnnotation?
    
    var pointLocation : [[Double]] = []
    var clusteringNumber : Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationButton.addShadow(opacity: 0.8 , radius: 1)
        clusteringNumberButton.addShadow(opacity: 0.8 , radius: 1)
        calculateKMeansButton.addShadow(opacity: 0.8 , radius: 1)
        infoButton.addShadow(opacity: 0.8, radius: 1)
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        self.mapView.addGestureRecognizer(longPressGesture)
        
    }
    @IBAction func calculateKMeansButtonTapped(_ sender: Any) {
        
        KMeansSwift.sharedInstance.addVectors(pointLocation)
        KMeansSwift.sharedInstance.clusteringNumber = clusteringNumber
        KMeansSwift.sharedInstance.clustering(500) {(success, centroids, clusters) -> () in
            if success {
                print("Centroids : \(centroids)")
                print("Clusters : \(clusters)")
                self.mapView.removeAnnotations(self.mapView.annotations)
                for i in 0 ... centroids.count-1 {
                    print (i)
                    let coordinateArr = centroids[i]
                    self.pin = LocationAnnotation(identifier: "Centroid", title: "Centroid", coordinate: CLLocationCoordinate2D(latitude: coordinateArr[0], longitude: coordinateArr[1]))
                    self.mapView.addAnnotation(self.pin!)
                }
                for i in 0 ... clusters.count-1 {
                    print (i)
                    if i == 0 {
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Green", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                    else if i == 1{
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Red", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                    else if i == 2{
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Blue", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func clusteringButtonTapped(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)!
        if buttonTitle == "2" {
            sender.setTitle("3",for: .normal)
            clusteringNumber = 3
        }
        else{
            sender.setTitle("2",for: .normal)
            clusteringNumber = 2
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
    }
    
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            //print(coordinate)
            pointLocation.append([coordinate.latitude,coordinate.longitude])
            self.pin = LocationAnnotation(identifier:"DarkGray", title: "Sample", coordinate: coordinate)
            
            self.mapView.addAnnotation(self.pin!)
            print(pointLocation)
            print("Min - Max Coordinates \(self.calculateMinMaxCordinate(locations: pointLocation))")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            let identifier = annotation.identifier
            
            switch identifier{
            case "DarkGray":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "DarkGray")
                //view.pinTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                view.image = UIImage(named: "darkGrayPoint")
                return view
            case "Green":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Green")
                //view.pinTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                view.image = UIImage(named: "greenPoint")
                return view
            case "Red":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Red")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "redPoint")
                return view
            case "Blue":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Blue")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "bluePoint")
                return view
            case "Centroid":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Centroid")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "Centroid")
                return view
                
            default:
                view.pinTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                view.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                return view
            }
            
        }
        return nil
    }
    
    func calculateMinMaxCordinate(locations: [[Double]]) ->  ([Double],[Double]) {
        var allLat : [Double] = []
        var allLon : [Double] = []
        for location in locations {
            allLat.append(location[0])
            allLon.append(location[1])
        }

        let minLat = allLat.min()
        let maxLat = allLat.max()
        let minLon = allLon.min()
        let maxLon = allLon.max()
        
        return ([minLat!,minLon!],[maxLat!,maxLon!])
        
    }
}


