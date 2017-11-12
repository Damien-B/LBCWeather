//
//  ActionTableViewCell.swift
//  LBCWeather
//
//  Created by Damien Bannerot on 12/11/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

	@IBOutlet weak var actionButton: UIButton!
	
	var delegate: ActionTableViewCellDelegate!
	
	var buttonTitle: String? {
		didSet {
			actionButton.setTitle(buttonTitle!, for: .normal)
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func buttonClicked(_ sender: UIButton) {
		delegate.buttonClicked()
	}
}

protocol ActionTableViewCellDelegate {
	func buttonClicked()
}
