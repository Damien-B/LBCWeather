//
//  APIManager.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class APIManager {
	
	static let shared = APIManager()
	
	enum APIError: Error {
		case callFailure
		case wrongDataFormat
		case failedCreatingForecast
	}
	
	fileprivate let baseURL = "https://www.infoclimat.fr/public-api/gfs/json?_ll="
	fileprivate let urlAuth = "&_auth=CRNRRlEvByVRfFZhVCJReAVtUmcIfgMkBHgEZw5rB3pUPwVkBmYEYl4wVSgHKFVjBShSMQkyBzdTOFAoDnwHZgljUT1ROgdgUT5WM1R7UXoFK1IzCCgDJARvBGoOfQdmVCkFZgZgBHheMFUwByhVfgU3UjcJNwc%2FUzRQMg5nB2IJblE9US0HelE7VmVUZFFiBWRSNwgwAzMENgRkDmUHYVRkBWAGewRhXjJVNQc3VWUFNlI3CTIHIFMvUE4OEAd5CSpRd1FnByNRI1ZhVDpRMQ%3D%3D"
	fileprivate let urlC = "&_c=fcf7b896fac2f9055562f5add8de4651"
	
	func retrieveForecast(forPosition position: CLLocation, completion: @escaping (_ error: Error?, _ forecast: APIForecast?) -> Void) {
		let url = "\(baseURL)\(position.coordinate.latitude),\(position.coordinate.longitude)\(urlAuth)\(urlC)"
		Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
			switch response.result {
			case .success(let data):
				guard let jsonData = data as? [String:Any] else {
					completion(APIError.wrongDataFormat, nil)
					break
				}
				guard let currentForecastDictionary = jsonData["\(Date().getForecastDateString())"] as? [String:Any] else {
					completion(APIError.wrongDataFormat, nil)
					break
				}
				do {
					let jsonData = try JSONSerialization.data(withJSONObject: currentForecastDictionary, options: .prettyPrinted)
					let decoder = JSONDecoder()
					let forecast = try decoder.decode(APIForecast.self, from: jsonData)
					completion(nil, forecast)
				} catch {
					completion(APIError.failedCreatingForecast, nil)
				}
				break
			case .failure:
				completion(APIError.callFailure, nil)
				break
			}
		}
	}
	
}
