//
//  Utils.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import Foundation


extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}
