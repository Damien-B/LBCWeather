//
//  Tests.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

// FUNCTIONAL TESTS - DEBUG PURPOSE ONLY
class Tests {

	func createCoreDataforecasts() {
		let loc = CLLocation(latitude: 48.8866182, longitude: 2.3357255)
		for i in 0...2 {
			APIManager.shared.retrieveForecast(forPosition: loc) { (error, forecast) in
				if let forecast = forecast {
					let entity = NSEntityDescription.entity(forEntityName: "Forecast", in: CoreDataManager.shared.managedObjectContext)!
					let test = Forecast.init(withAPIForecast: forecast, position: loc, date: Date(), isUserLocation: i==2, entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
				}
			}
		}
	}
	
	func getSavedForecastsCount() -> Int {
		return CoreDataManager.shared.retrieveAllSavedForecasts().count
	}
	
}
