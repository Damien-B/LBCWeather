//
//  ForecastSplitViewController.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit


class ForecastSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.delegate = self
		if let leftNavController = self.viewControllers.first as? UINavigationController, let masterViewController = leftNavController.topViewController as? ForecastListTableViewController {
			masterViewController.splitViewDelegate = self
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
	
}

extension ForecastSplitViewController: SplitViewDelegate {
	func showDetailView(withForecast forecast: Forecast) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let detailViewController = storyboard.instantiateViewController(withIdentifier: "ForecastDetailViewController") as! ForecastDetailViewController
		detailViewController.forecast = forecast
		self.showDetailViewController(detailViewController, sender: self)
	}
}
