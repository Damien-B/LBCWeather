//
//  APIManagerTests.swift
//  LBCWeatherTests
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LBCWeather

class APIManagerTests: XCTestCase {
	
	private let parisLocation = CLLocation(latitude: 48.8866182, longitude: 2.3357255)
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPICall() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		let APIExpectation = expectation(description: "API call returns under 10 seconds")
		
		APIManager.shared.retrieveForecast(forPosition: parisLocation) { (error, forecast) in
			XCTAssertNotNil(forecast)
			if let test = forecast {
				print(test)
			}
			APIExpectation.fulfill()
		}
		waitForExpectations(timeout: 10) { error in
			if let error = error {
				print("Error: \(error.localizedDescription)")
			}
		}
    }
    
}
