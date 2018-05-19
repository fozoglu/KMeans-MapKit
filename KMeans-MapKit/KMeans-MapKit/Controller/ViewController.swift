//
//  ViewController.swift
//  KMeans-MapKit
//
//  Created by Furkan Ozoglu on 4.04.2018.
//  Copyright © 2018 fozoglu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var clusteringNumberButton: UIButton!
    @IBOutlet var clusteringNumberUpButton: UIButton!
    @IBOutlet var clusteringNumberDownButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var calculateKMeansButton: UIButton!
    //Private Variable
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var pin : LocationAnnotation?
    //Public Variable
    var pointLocation : [[Double]] = []
    var clusteringNumber : Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
       
        //Add Shadow for Button
        locationButton.addShadow(opacity: 0.8 , radius: 1)
        clusteringNumberButton.addShadow(opacity: 0.8 , radius: 1)
        clusteringNumberUpButton.addShadow(opacity: 0.8 , radius: 1)
        clusteringNumberDownButton.addShadow(opacity: 0.8 , radius: 1)
        calculateKMeansButton.addShadow(opacity: 0.8 , radius: 1)
        
        //LongPressGesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        self.mapView.addGestureRecognizer(longPressGesture)
        
    }
    //Calculate KMeans Button
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
                    //print (i)
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
                    else if i == 3{
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Purple", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                    else if i == 4{
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Pink", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                    else if i == 5{
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Orange", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                    else if i == 6{
                        let coordinateArr = clusters[i]
                        for coordinate in coordinateArr {
                            self.pin = LocationAnnotation(identifier: "Yellow", title: "Sample", coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
                            
                            self.mapView.addAnnotation(self.pin!)
                        }
                    }
                }
            }
        }
        
    }
    /*
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
    */
    // Clustering Number Upper
    @IBAction func clusteringNumberUpButtonTapped(_ sender: UIButton) {
         let buttonTitle = clusteringNumberButton.title(for: .normal)!
        if Int(buttonTitle)! < 8  {
            let value = Int(buttonTitle)! + 1
            clusteringNumberButton.setTitle(value.description,for: .normal)
            clusteringNumber = value
        }
        else {
            
        }
    }
    // Clustering Number Down
    @IBAction func clusteringNumberDowmButtonTapped(_ sender: UIButton) {
        let buttonTitle = clusteringNumberButton.title(for: .normal)!
        if Int(buttonTitle)! > 2  {
            let value = Int(buttonTitle)! - 1
            clusteringNumberButton.setTitle(value.description,for: .normal)
            clusteringNumber = value
        }
    }
    // Location Button
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    //
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            //print(coordinate)
            pointLocation.append([coordinate.latitude,coordinate.longitude])
            self.pin = LocationAnnotation(identifier:"DarkGray", title: "Sample", coordinate: coordinate)
            
            self.mapView.addAnnotation(self.pin!)
            //print(pointLocation)
            //print("Min - Max Coordinates \(self.calculateMinMaxCordinate(locations: pointLocation))")
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
            case "Purple":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Purple")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "purplePoint")
                return view
            case "Pink":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pink")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "pinkPoint")
                return view
            case "Orange":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Orange")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "orangePoint")
                return view
            case "Yellow":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Yellow")
                //view.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                //view.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                view.image = UIImage(named: "yellowPoint")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        if self.mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
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


