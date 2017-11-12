//
//  APIForecastTests.swift
//  LBCWeatherTests
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import XCTest
@testable import LBCWeather

class APIForecastTests: XCTestCase {
	
	let forecastJsonString = """
{
"temperature": {
"2m": 283,
"sol": 283.3,
"500hPa": -0.1,
"850hPa": -0.1
},
"pression": {
"niveau_de_la_mer": 100930
},
"pluie": 1.6,
"pluie_convective": 0,
"humidite": {
"2m": 90.6
},
"vent_moyen": {
"10m": 8.5
},
"vent_rafales": {
"10m": 17.8
},
"vent_direction": {
"10m": 526
},
"iso_zero": 2276,
"risque_neige": "non",
"cape": 0,
"nebulosite": {
"haute": 0,
"moyenne": 76,
"basse": 100,
"totale": 100
}
}
"""
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testDecodingAPIForecast() {
		let jsonData = forecastJsonString.data(using: .utf8)!
		let decoder = JSONDecoder()
		let forecast = try? decoder.decode(APIForecast.self, from: jsonData)
		XCTAssertNotNil(forecast)
		if let forecast = forecast {
			// generic tests
//			XCTAssertGreaterThanOrEqual(forecast.rain, 0)
//			XCTAssertGreaterThanOrEqual(forecast.wind, 0)
//			XCTAssertGreaterThanOrEqual(forecast.windDirection, 0)
//			XCTAssertGreaterThanOrEqual(forecast.nebulosity, 0)
//			XCTAssertLessThanOrEqual(forecast.nebulosity, 100)
			// special case tests
			XCTAssertEqual(forecast.rain, 1.6, accuracy: 0.1)
			XCTAssertEqual(forecast.temperature, 283.3, accuracy: 0.1)
			XCTAssertEqual(forecast.wind, 8.5, accuracy: 0.1)
			XCTAssertEqual(forecast.windDirection, 526)
			XCTAssertEqual(forecast.nebulosity, 100)
		}
	}
    
}
