//
//  APIForecast.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation

struct APIForecast: Decodable {
	
	var temperature: Float
	var rain: Float
	var wind: Float
	var windDirection: Int
	var nebulosity: Int
	
	enum CodingKeys: String, CodingKey {
		case temperature
		case rain = "pluie"
		case windPower = "vent_moyen"
		case windDirection = "vent_direction"
		case nebulosityInfo = "nebulosite"
	}
	
	enum TemperatureInfoCodingKeys: String, CodingKey {
		case ground = "sol"
	}
	enum WindPowerCodingKeys: String, CodingKey {
		case power = "10m"
	}
	enum WindDirectionCodingKeys: String, CodingKey {
		case direction = "10m"
	}
	enum NebulosityInfoCodingKeys: String, CodingKey {
		case index = "totale"
	}
	
	init(from decoder: Decoder) throws {
		// retrieve first level informations
		let values = try decoder.container(keyedBy: CodingKeys.self)
		rain = try values.decode(Float.self, forKey: .rain)
		
		// retrieve nested informations
		let temperatureInfo = try values.nestedContainer(keyedBy: TemperatureInfoCodingKeys.self, forKey: .temperature)
		temperature = try temperatureInfo.decode(Float.self, forKey: .ground)
		let windPower = try values.nestedContainer(keyedBy: WindPowerCodingKeys.self, forKey: .windPower)
		wind = try windPower.decode(Float.self, forKey: .power)
		let direction = try values.nestedContainer(keyedBy: WindDirectionCodingKeys.self, forKey: .windDirection)
		windDirection = try direction.decode(Int.self, forKey: .direction)
		let nebulosityInfo = try values.nestedContainer(keyedBy: NebulosityInfoCodingKeys.self, forKey: .nebulosityInfo)
		nebulosity = try nebulosityInfo.decode(Int.self, forKey: .index)
	}
}
