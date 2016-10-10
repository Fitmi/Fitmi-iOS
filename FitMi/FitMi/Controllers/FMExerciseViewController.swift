//
//  FMExerciseViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import CoreMotion

class FMExerciseViewController: FMViewController {

	private static var defaultController: FMExerciseViewController?
	
	@IBOutlet var statusPanelView: UIView!
	@IBOutlet var statusPanelTitleContainer: UIView!
	@IBOutlet var statusPanelTitleLabel: UILabel!
	@IBOutlet var spriteView: SKView!
	
	@IBOutlet var buttonStartExercise: UIButton!
	@IBOutlet var buttonEndExercise: UIButton!
	
	@IBOutlet var labelDuration: UILabel!
	@IBOutlet var labelStepCount: UILabel!
	@IBOutlet var labelDistance: UILabel!
	@IBOutlet var labelFlights: UILabel!
	
	var exerciseStartDate: Date!
	var exerciseEndDate: Date!
	var stepCount: Int = 0
	var distance: Int = 0
	var flights: Int = 0
	var durationUpdateTimer: Timer!
	
    private let motionStatusManager = FMMotionStatusManager.sharedManager
	
	override func loadView() {
		super.loadView()
		
		self.view.backgroundColor = UIColor.secondaryColor
        motionStatusManager.delegate = self
		
		do {
			self.statusPanelView.backgroundColor = UIColor.white
			let layer = self.statusPanelView.layer
			layer.borderWidth = 3
			layer.borderColor = UIColor.black.cgColor
		}
		
		do {
			self.statusPanelTitleContainer.backgroundColor = UIColor.white
			let layer = self.statusPanelTitleContainer.layer
			layer.borderWidth = 3
			layer.borderColor = UIColor.black.cgColor
		}
		
		do {
			if let scene = SKScene(fileNamed: "FMMainScene") {
				scene.scaleMode = .aspectFill
				self.spriteView.presentScene(scene)
			}
			
			self.spriteView.ignoresSiblingOrder = true
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if FMExerciseViewController.defaultController == nil {
			FMExerciseViewController.defaultController = self
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	class func getDefaultController() -> FMExerciseViewController {
		if FMExerciseViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMExerciseViewController") as! FMExerciseViewController
			FMExerciseViewController.defaultController = controller
		}
		
		return FMExerciseViewController.defaultController!
	}

	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
	}
	
	override func willMoveAway(fromParentViewController parent: UIViewController?) {
	}
	
	func updateDurationLabel() {
		let duration = Int(Date().timeIntervalSince(self.exerciseStartDate))
		let hour = duration / 3600
		let min = (duration - hour * 3600) / 60
		let sec = duration % 60
		DispatchQueue.main.async {
			self.labelDuration.text = "\(hour < 10 ? "0": "")\(hour) : \(min < 10 ? "0": "")\(min) : \(sec < 10 ? "0": "")\(sec)"
		}
	}
	
	func generateExerciseReport() {
		print("Exercise Finished")
		print("Steps: \(self.stepCount)")
		print("Distance: \(self.distance)")
		print("Flights: \(self.flights)")
		print("Start: \(self.exerciseStartDate)")
		print("End: \(self.exerciseEndDate)")
		print("Duration: \(self.exerciseEndDate.timeIntervalSince(self.exerciseStartDate))")
		
		if !(self.stepCount == 0 && self.distance == 0 && self.flights == 0) {
			let record = FMExerciseRecord()
			record.steps = self.stepCount
			record.distance = self.distance
			record.flights = self.flights
			record.startTime = self.exerciseStartDate
			record.endTime = self.exerciseEndDate
			
			let databaseManager = FMDatabaseManager.sharedManager
			databaseManager.realmUpdate {
				databaseManager.getCurrentSprite().exercises.append(record)
			}
		}
	}
	
	@IBAction func toggleExercise(_ sender: AnyObject) {
		
	}

    @IBAction func startExercise(_ sender: AnyObject) {
        motionStatusManager.startMotionUpdates()
		self.buttonStartExercise.isEnabled = false
		self.buttonStartExercise.alpha = 0.4
		self.buttonEndExercise.isEnabled = true
		self.buttonEndExercise.alpha = 1
		self.exerciseStartDate = Date()
		self.durationUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDurationLabel), userInfo: nil, repeats: true)
    }
    
    @IBAction func endExercise(_ sender: AnyObject) {
        motionStatusManager.stopMotionUpdates()
		self.buttonStartExercise.isEnabled = true
		self.buttonStartExercise.alpha = 1
		self.buttonEndExercise.isEnabled = false
		self.buttonEndExercise.alpha = 0.4
		self.exerciseEndDate = Date()
		self.durationUpdateTimer.invalidate()
		
		self.generateExerciseReport()
    }
}

extension FMExerciseViewController: FMMotionStatusDelegate {
    func motionStatusManager(manager: FMMotionStatusManager, didRecieveMotionData data: CMPedometerData) {
		DispatchQueue.main.async {
			self.stepCount = Int(data.numberOfSteps)
			self.labelStepCount.text = "\(self.stepCount)"
			
			
			if manager.isDistanceAvailable() {
				self.distance = Int(data.distance!)
				self.labelDistance.text = "\(self.distance) m"
			}
			
			if manager.isFloorCountingAvailable() {
				self.flights = Int(data.floorsAscended!)
				self.labelFlights.text = "\(self.flights)"
			}
		}
    }
    
    func motionStatusManager(manager: FMMotionStatusManager, didRecieveActivityData data: CMMotionActivity) {
        // TODO: collect the data and reflect them in the view
        if data.running {
            print("Activity: running")
        } else if data.cycling {
            print("Activity: cycling")
        } else if data.walking {
            print("Activity: walking")
        } else if data.stationary {
            print("Activity: still")
        } else {
            print("Activity: unknown")
        }
    }
}
