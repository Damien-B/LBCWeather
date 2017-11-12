//
//  Forecast+CoreDataClass.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Forecast)
public class Forecast: NSManagedObject {
	
	

	convenience init(withAPIForecast forecast: APIForecast, cityName: String = "Lieu inconnu", position: CLLocation, date: Date, isUserLocation: Bool = false, entity: NSEntityDescription, insertInto managedObjectContext: NSManagedObjectContext) {
		self.init(entity: entity, insertInto: managedObjectContext)
		self.cityName = cityName
		temperature = forecast.temperature
		latitude = position.coordinate.latitude
		longitude = position.coordinate.longitude
		wind = forecast.wind
		windDirection = Int16(forecast.windDirection)
		nebulosity = Int16(forecast.nebulosity)
		self.date = date as NSDate
		self.isUserLocation = isUserLocation
		do {
			try CoreDataManager.shared.managedObjectContext.save()
		} catch {
			print(error.localizedDescription)
		}
	}
}
