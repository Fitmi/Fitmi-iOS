//
//  FMWorkoutHistoryViewController.swift
//  FitMi
//
//  Created by Jiang Sheng on 14/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMWorkoutHistoryViewController: FMViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    private static var defaultController: FMWorkoutHistoryViewController?
    
    fileprivate var sprite: FMSprite?
    fileprivate var numberOfRecords = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FMWorkoutHistoryViewController.defaultController == nil {
            FMWorkoutHistoryViewController.defaultController = self
        }
        
        // init
        DispatchQueue.main.async {
            self.sprite = FMSpriteStatusManager.sharedManager.sprite
            self.configureTableView()
            self.registerCells()
        }
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.sprite = FMSpriteStatusManager.sharedManager.sprite
		self.numberOfRecords = min(self.sprite!.exercises.count, 14)
		self.tableView.reloadData()
		if self.sprite?.exercises.count == 0 {
			let label = UILabel()
			label.text = "YOU HAVE NO IN-APP WORKOUT RECORD."
			label.numberOfLines = 0
			label.textAlignment = .center
			label.font = UIFont(name: "Pixeled", size: 8)
			self.tableView.backgroundView = label
		} else {
			self.tableView.backgroundView = nil
		}
		
		if self.numberOfRecords > 0 {
			let indexPath = IndexPath(row: self.numberOfRecords - 1, section: 0)
			self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
		}
	}
    
    private func configureTableView() {
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(tableDidRefreshed), for: .valueChanged)
        
        self.numberOfRecords = min(sprite!.exercises.count, 14)
    }
    
    func tableDidRefreshed() {
        let newNumberOfStates = numberOfRecords + 7
        numberOfRecords = min(sprite!.exercises.count, newNumberOfStates)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refresh), userInfo: nil, repeats: false)
    }
    
    func refresh() {
        self.refreshControl.endRefreshing()
		if self.numberOfRecords != 0 && self.tableView.backgroundView != nil	{
			self.tableView.backgroundView = nil
		}
        self.tableView.reloadSections([0], with: .automatic)
    }
    
    private func registerCells() {
        FMWorkoutHistoryCell.registerCell(tableView: self.tableView, reuseIdentifier: FMWorkoutHistoryCell.identifier)
    }
    
    class func getDefaultController() -> FMWorkoutHistoryViewController {
        if FMWorkoutHistoryViewController.defaultController == nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FMWorkoutHistoryViewController") as! FMWorkoutHistoryViewController
            FMWorkoutHistoryViewController.defaultController = controller
        }
        
        return FMWorkoutHistoryViewController.defaultController!
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension FMWorkoutHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.numberOfRecords
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: FMWorkoutHistoryCell.identifier, for: indexPath) as! FMWorkoutHistoryCell
            cell.selectionStyle = .none

            let index = self.sprite!.exercises.count - (self.numberOfRecords - indexPath.row)
            cell.configureCell(withExercise: self.sprite!.exercises[index])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FMWorkoutHistoryCell.identifier, for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
}
