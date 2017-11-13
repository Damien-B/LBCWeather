//
//  Utils.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation



 let userLocationKey = "UserLocation"
 let userLocationCityNameKey = "UserLocationCityName"

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
	func toDate() -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.date(from: self)
	}
}


extension Date {
	func getForecastDateString() -> String {
		// set current date in user timezone
		var forecastDate = Date()
		var calendar = Calendar.current
		calendar.timeZone = .current
		// find hour corresponding to the API hour intervals
		while calendar.dateComponents([.hour], from: forecastDate).hour!%3 != 1 {
			forecastDate.addTimeInterval(-3600)
		}
		// get clean date without minutes and seconds
		let forecastDateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: forecastDate)
		let cleanForecastDate = calendar.date(from: forecastDateComponents)!
		// formatting the date to string
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.string(from: cleanForecastDate)
	}
}

extension Float {
	func toCelsius() -> Float {
		return self-273.15
	}
}
