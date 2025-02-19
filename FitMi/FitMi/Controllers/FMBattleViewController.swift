//
//  FMBattleViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import BubbleTransition

class FMBattleViewController: FMViewController {
	
	@IBOutlet var tableView: UITableView!
	
	let transition = BubbleTransition()
	var segueStartCenter = CGPoint.zero
	
	fileprivate var data:JSON?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.registerCells()
        self.configureTableView()
    }
	
	private func registerCells() {
		FMFriendListCell.registerCell(tableView: self.tableView, reuseIdentifier: FMFriendListCell.identifier)
		FMBeatMyselfCell.registerCell(tableView: self.tableView, reuseIdentifier: FMBeatMyselfCell.identifier)
	}

	private func configureTableView() {
		self.tableView.estimatedRowHeight = 100
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 88, right: 0)
		self.tableView.backgroundColor = UIColor.secondaryColor
		
		self.tableView.delaysContentTouches = false
		
		for case let x as UIScrollView in self.tableView.subviews {
			x.delaysContentTouches = false
		}
		
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		headerLabel.font = UIFont(name: "Pixeled", size: 20)
		headerLabel.text = "BATTLE!"
		headerLabel.textAlignment = .center
		self.tableView.tableHeaderView = headerLabel
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		
		if self.data == nil || self.data?.count == 0 {
			let indicatorView = UILabel()
			indicatorView.text = "Loading Friends..."
			indicatorView.font = UIFont(name: "Pokemon Pixel Font", size: 20)
			indicatorView.textAlignment = .center
			
			self.tableView.backgroundView = indicatorView
		}
		
		let prefs = UserDefaults.standard
		if prefs.string(forKey: "jwt") == nil {
			let indicatorView = self.tableView.backgroundView as! UILabel
			self.data = nil
			indicatorView.isHidden = false
			indicatorView.numberOfLines = 0
			indicatorView.text = "Login to Facebook in Settings page\nto play with your friends."
			self.tableView.reloadData()
			return
		}
		
		
		FMNetworkManager.sharedManager.getFriendList(completion: {
			error, friendList in
			if error == nil && friendList != nil {
				self.data = friendList!
				if let indicator = self.tableView.backgroundView as? UILabel {
					if self.data?.count == 0 {
						indicator.text = "None of your Facebook friends is on FitMi"
                        FMGameCenterManager.sharedManager.completeAchievement(achievementId: AchievementId.NO_FB_FRIENDS.rawValue)
					} else {
						indicator.isHidden = true
					}
				}
				self.tableView.reloadData()
			}
		})
	}
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
	}
	
	private static var defaultController: FMBattleViewController?
	class func getDefaultController() -> FMBattleViewController {
		if FMBattleViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMBattleViewController") as! FMBattleViewController
			FMBattleViewController.defaultController = controller
		}
		
		return FMBattleViewController.defaultController!
	}

}

extension FMBattleViewController: UIViewControllerTransitioningDelegate {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let controller = segue.destination
		transition.duration = 0.2
		controller.transitioningDelegate = self
		controller.modalPresentationStyle = .custom
		
		if segue.identifier == "combatSegue" {
			let controller = segue.destination as! FMBattleDetailViewController
			let indexPath = sender as! IndexPath
			if indexPath.section == 1 {
				let id = "\(self.data![indexPath.row]["facebookId"])"
				controller.opponentID = id
			}
		}
	}
	
	// MARK: UIViewControllerTransitioningDelegate
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .present
		transition.startingPoint = self.segueStartCenter
		transition.bubbleColor = UIColor.primaryColor
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		transition.startingPoint = self.segueStartCenter
		transition.bubbleColor = UIColor.primaryColor
		return transition
	}
}


extension FMBattleViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 1 {
			return self.data == nil ? 0 : self.data!.count
		} else {
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: FMFriendListCell.identifier, for: indexPath) as! FMFriendListCell
			
			let row = indexPath.row
			cell.contentView.backgroundColor = row % 2 == 1 ? UIColor(white: 1, alpha: 0.3) : UIColor.clear
			
			let json = self.data![row]
			
			cell.nameLabel.text = json["username"].string
			cell.avatarImageView.image = UIImage(named: "placeholder")
			cell.avatarImageView.af_setImage(withURL: URL(string: "http://graph.facebook.com/\(json["facebookId"])/picture?type=large")!)
			cell.levelLabel.text = "lv. \(json["level"])"
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: FMBeatMyselfCell.identifier, for: indexPath) as! FMBeatMyselfCell
			return cell
		}
	}
}

extension FMBattleViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.segueStartCenter = self.view.center
		self.performSegue(withIdentifier: "combatSegue", sender: indexPath)
	}
}
