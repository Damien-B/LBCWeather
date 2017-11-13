//
//  ForecastDetailViewController.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {

	// headline informations labels
	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var gpsPositionLabel: UILabel!
	// labels outlets for different weather informations
	@IBOutlet weak var temperatureTitleLabel: UILabel!
	@IBOutlet weak var windTitleLabel: UILabel!
	@IBOutlet weak var nebulosityTitleLabel: UILabel!
	@IBOutlet weak var rainTitleLabel: UILabel!
	// data outlets
	@IBOutlet weak var temperatureDataLabel: UILabel!
	@IBOutlet weak var windDataLabel: UILabel!
	@IBOutlet weak var nebulosityDataLabel: UILabel!
	@IBOutlet weak var rainDataLabel: UILabel!
	
	var forecast: Forecast?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers
	
	func updateUI() {
		temperatureTitleLabel.text = "FORECAST_DETAIL_VIEW_TEMPERATURE_TITLE".localized
		windTitleLabel.text = "FORECAST_DETAIL_VIEW_WIND_TITLE".localized
		nebulosityTitleLabel.text = "FORECAST_DETAIL_VIEW_NEBULOSITY_TITLE".localized
		rainTitleLabel.text = "FORECAST_DETAIL_VIEW_RAIN_TITLE".localized
		if let forecast = forecast {
			cityNameLabel.text = forecast.cityName
			gpsPositionLabel.text = "\(String(format: "%.5f",forecast.latitude)), \(String(format: "%.5f", forecast.longitude))"
			temperatureDataLabel.text = String(format: "%.1f°C", forecast.temperature.toCelsius())
			windDataLabel.text = String(format: "%.1f Km/h", forecast.wind)
			nebulosityDataLabel.text = "\(Int(forecast.nebulosity))%"
			rainDataLabel.text = String(format: "%.1fmm", forecast.rain)
			title = forecast.cityName
		}
	}
	

}
