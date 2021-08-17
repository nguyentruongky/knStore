//
//  LocationWorker.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/16/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
import CoreLocation

typealias KNLocationData = (lat: Double, long: Double)


class KNLocationWorker: NSObject {
    
    var responseToSuccess: ((KNLocationData) -> Void)?
    var responseToFail: ((KNError) -> Void)?
    
    init(responseToSuccess: ((KNLocationData) -> Void)?, responseToFail: ((KNError) -> Void)?) {
        self.responseToSuccess = responseToSuccess
        self.responseToFail = responseToFail
    
    }
    
    var locationManager : CLLocationManager? = CLLocationManager()
    
    func execute() {
        
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

extension KNLocationWorker : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let userLocation:CLLocation = locations[0] as CLLocation
        let longitude = userLocation.coordinate.longitude
        let latitude = userLocation.coordinate.latitude
        
        let location = KNLocationData(latitude, longitude)
        locationManager = nil 
        responseToSuccess?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let err = KNError(code: "get_location_fail", message: error.localizedDescription)
        responseToFail?(err)
    }
}


