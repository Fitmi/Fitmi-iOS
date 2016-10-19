//
//  FMBoothItemCell.swift
//  FitMi
//
//  Created by Jinghan Wang on 19/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMBoothItemCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var button: UIButton!
	
	var object: Any?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		let normalImage = UIImage.fromColor(color: UIColor.activeColor)
		let highlightedImage = UIImage.fromColor(color: UIColor.gray)
		
		self.button.setBackgroundImage(normalImage, for: .normal)
		self.button.setBackgroundImage(highlightedImage, for: .highlighted)
    }
	
	@IBAction func buttonDidClick() {
		let title = self.button.title(for: .normal)
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BOOTH_BUTTON_DID_CLICK_NOTIFICATION"), object: self.object, userInfo:["USING": title == "USING"])
	}
	
	func setButtonState(inUse: Bool) {
		if inUse {
			let normalImage = UIImage.fromColor(color: UIColor.darkGray)
			self.button.setBackgroundImage(normalImage, for: .normal)
			self.button.setTitle("USING", for: .normal)
		} else {
			let normalImage = UIImage.fromColor(color: UIColor.activeColor)
			self.button.setBackgroundImage(normalImage, for: .normal)
			self.button.setTitle("USE", for: .normal)
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		
		if self.contentView.alpha != 1 {
			return
		}
		
		
		let animationDuration: TimeInterval = highlighted ? 0.0 : 0.1
		
		UIView.animate(withDuration: animationDuration, animations: {
			if highlighted {
				self.contentView.backgroundColor = UIColor.secondaryColor
			} else {
				self.contentView.backgroundColor = self.backgroundColor
			}
		})
	}
	
	static let identifier = "FMBoothItemCell"
	class func registerCell(tableView: UITableView, reuseIdentifier: String) {
		let nib = UINib(nibName: "FMBoothItemCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
