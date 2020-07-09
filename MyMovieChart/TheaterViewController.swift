//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by JSMAC on 2019/12/21.
//  Copyright © 2019 JSPRO. All rights reserved.
//

import UIKit
import MapKit

class TheaterViewController: UIViewController {
    var param: NSDictionary!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        self.navigationItem.title = self.param["상영관명"] as? String
        let lat = (self.param?["위도"] as! NSString).doubleValue
        let lng = (self.param?["경도"] as! NSString).doubleValue
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let regionRadius: CLLocationDistance = 100
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.map.setRegion(coordinateRegion, animated: true)
        
        // 위치를 표시
        let point = MKPointAnnotation()
        point.coordinate = location
        
        self.map.addAnnotation(point)
        
    }
}
