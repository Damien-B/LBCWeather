//
//  LocationManager.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
	
	static let shared = LocationManager()
	var manager = CLLocationManager()
	var userLocation: CLLocation?
	var userLocationCityName: String?
	
	override init() {
		super.init()
		manager.delegate = self
	}
	
	// MARK: - Helpers
	
	func updateUserLocation() {
		if CLLocationManager.locationServicesEnabled() {
			manager.requestWhenInUseAuthorization()
			manager.desiredAccuracy = 10
			manager.distanceFilter = 1000
			manager.startUpdatingLocation()
		}
	}
	
}


extension LocationManager: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			userLocation = location
			let geoCoder = CLGeocoder()
			geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
				if let placemarks = placemarks {
					if let place = placemarks.first {
						self.userLocationCityName = place.name
					}
				}
			})
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}
