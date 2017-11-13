//
//  ForecastListTableViewController.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

protocol SplitViewDelegate {
	func showDetailView(withForecast: Forecast)
}

class ForecastListTableViewController: UITableViewController {

	var userLocationForecast: Forecast?
	var forecasts: [Forecast] = []
	var splitViewDelegate: SplitViewDelegate?
	var newForecastText: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// self-sizing cells
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		
		tableView.delegate = self
		tableView.dataSource = self
		title = "LBC Weather"
		
		if let userLocationForecast = CoreDataManager.shared.retrieveUserLocationForecast() {
			self.userLocationForecast = userLocationForecast
		} else {
			getUserLocationForecast()
		}
		forecasts = CoreDataManager.shared.retrieveAllSavedForecasts()
		tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return forecasts.count+1
		default:
			return 0
		}
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			if let forecast = userLocationForecast {
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell {
					cell.cityNameLabel.text = forecast.cityName!
					cell.temperatureLabel.text = String(format: "%.1f°C", forecast.temperature.toCelsius())
					return cell
				}
			} else {
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ActionTableViewCell {
					cell.buttonTitle = "FORECAST_LIST_VIEW_USE_LOCATION".localized
					cell.delegate = self
					return cell
				}
			}
		case 1:
			if indexPath.row != forecasts.count {
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell {
					cell.cityNameLabel.text = forecasts[indexPath.row].cityName!
					cell.temperatureLabel.text = String(format: "%.1f°C", forecasts[indexPath.row].temperature.toCelsius())
					return cell
				}
			} else {
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ActionTableViewCell {
					cell.buttonTitle = "FORECAST_LIST_VIEW_ADD_LOCATION".localized
					cell.delegate = self
					return cell
				}
				
			}
		default:
			break
		}
		let cell = UITableViewCell()
		return cell
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "FORECAST_LIST_VIEW_USER_POSITION_TITLE".localized
		}
		return "FORECAST_LIST_VIEW_SAVED_POSITION_TITLE".localized
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath)!.isKind(of: ForecastTableViewCell.self) {
			if let delegate = splitViewDelegate {
				delegate.showDetailView(withForecast: indexPath.section == 0 ? userLocationForecast! : forecasts[indexPath.row])
			}
		}
		tableView.deselectRow(at: indexPath, animated: false)
	}

}

// MARK: - ActionTableViewCellDelegate

extension ForecastListTableViewController: ActionTableViewCellDelegate {
	func buttonClicked(atIndexPath indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			getUserLocationForecast()
		case 1:
			
			var TF: UITextField?
			// Create the AlertController
			let actionSheetController: UIAlertController = UIAlertController(title: "Ajouter une ville", message: "", preferredStyle: .alert)
			
			// Create and add the Cancel action
			let cancelAction: UIAlertAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
				actionSheetController.dismiss(animated: true, completion: nil)
			}
			let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
				self.newForecastText = TF!.text!
				LocationManager.shared.location(fromAddress: self.newForecastText!, completion: { (location) in
					if let location = location {
						APIManager.shared.retrieveForecast(forPosition: location, completion: { (error, forecast) in
							if let forecast = forecast {
								CoreDataManager.shared.saveForecast(withForecast: forecast, location: location, cityName: self.newForecastText!)
								self.forecasts = CoreDataManager.shared.retrieveAllSavedForecasts()
								self.tableView.reloadData()
							}
						})
					}
				})
			}
			actionSheetController.addAction(cancelAction)
			actionSheetController.addAction(nextAction)
			// add a textfield
			actionSheetController.addTextField(configurationHandler: { (textField) in
				TF = textField
			})
			
			//Present the AlertController
			self.present(actionSheetController, animated: true, completion: nil)
		default:
			break
		}
		
	}
	
	
	
}

// MARK: - Helpers

extension ForecastListTableViewController {
	func getUserLocationForecast() {
		LocationManager.shared.updateUserLocation()
		if let location = LocationManager.shared.userLocation, let cityName = LocationManager.shared.userLocationCityName {
			APIManager.shared.retrieveForecast(forPosition: location, completion: { (error, forecast) in
				if let forecast = forecast {
					CoreDataManager.shared.updateUserLocationForecast(withForecast: forecast, location: location, cityName: cityName)
					if let userLocationForecast = CoreDataManager.shared.retrieveUserLocationForecast() {
						self.userLocationForecast = userLocationForecast
						self.tableView.reloadData()
					}
				}
			})
		}
	}
}

