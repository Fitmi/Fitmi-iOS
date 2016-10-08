//
//  FMHealthStatusManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import HealthKit

class FMHealthStatusManager: NSObject {
	static let sharedManager = FMHealthStatusManager()
	
	private let healthKitStore:HKHealthStore = HKHealthStore()
	
	var stepsForToday: Int = 0
	var distanceForToday: Int = 0
	var flightsForToday: Int = 0
	
	func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!){
		let readTypes: Set<HKQuantityType> = Set([
			HKObjectType.quantityType(forIdentifier: .stepCount)!,
			HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
			HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
		])
		
		if !HKHealthStore.isHealthDataAvailable() {
			let error = NSError(domain: APPLICATION_ERROR_DOMAIN, code: ERROR_CODE_HEALTH_DATA_NOT_AVAILABLE, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this device"])
			if (completion != nil) {
				completion!(false, error)
			}
			
			return
		}
		
		self.healthKitStore.requestAuthorization(toShare: nil, read: readTypes, completion: {
			(success, error) -> Void in
			
			if (completion != nil) {
				completion!(success, error as NSError?)
			}
			
		})
	}
	
	func stepsForDate(date: Date, completion: @escaping (_ error: Error?, _ value: Int) -> Void) {
		let calendar = Calendar.current
		self.quantity(startDate: calendar.startOfDay(for: date), endDate: calendar.endOfDay(for: date), type: .stepCount, completion: {
			error, value in
			if error != nil && calendar.isDateInToday(date) {
				self.stepsForToday = value
			}
			completion(error, value)
		})
	}
	
	func distanceForDate(date: Date, completion: @escaping (_ error: Error?, _ value: Int) -> Void) {
		let calendar = Calendar.current
		self.quantity(startDate: calendar.startOfDay(for: date), endDate: calendar.endOfDay(for: date), type: .distanceWalkingRunning, completion: {
			error, value in
			if error != nil && calendar.isDateInToday(date) {
				self.distanceForToday = value
			}
			completion(error, value)
		})
	}
	
	func flightsForDate(date: Date, completion: @escaping (_ error: Error?, _ value: Int) -> Void) {
		let calendar = Calendar.current
		self.quantity(startDate: calendar.startOfDay(for: date), endDate: calendar.endOfDay(for: date), type: .flightsClimbed, completion: {
			error, value in
			if error != nil && calendar.isDateInToday(date) {
				self.flightsForToday = value
			}
			completion(error, value)
		})
	}
	
	
	func quantity(startDate: Date, endDate: Date, type: HKQuantityTypeIdentifier, completion: @escaping (_ error: Error?, _ value: Int) -> Void) {
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let calendar = NSCalendar.current
		let interval = NSDateComponents()
		interval.day = 1
		var anchorComponents = calendar.dateComponents(Set([.day, .month, .year]), from: Date())
		anchorComponents.hour = 0
		let anchorDate = calendar.date(from: anchorComponents)
		
		let query = HKStatisticsCollectionQuery(quantityType: HKObjectType.quantityType(forIdentifier: type)!,
		                                        quantitySamplePredicate: predicate,
		                                        options: .cumulativeSum,
		                                        anchorDate: anchorDate!,
		                                        intervalComponents: interval as DateComponents)
		query.initialResultsHandler = {
			query, results, error in
			if error != nil {
				completion(error, 0)
			} else {
				var value = 0;
				results?.enumerateStatistics(from: startDate,to: endDate, with: {
					result, stop in
					if let quantity = result.sumQuantity() {
						if (type == .distanceWalkingRunning) {
							value += Int(quantity.doubleValue(for: HKUnit.meter()))
						} else if (type == .stepCount || type == .flightsClimbed) {
							value += Int(quantity.doubleValue(for: HKUnit.count()))
						} else {
							print("Identifier Type Not Supported")
							completion(nil, 0)
							return
						}
					}
				})
				completion(nil, value)
			}
			
		}
		
		self.healthKitStore.execute(query)
	}
	
	func quantity(daysBack: Int, type: HKQuantityTypeIdentifier, completion: @escaping (_ error: Error?, _ dates:[Date], _ values: [Int]) -> Void) {
		let calendar = NSCalendar.current
		let interval = NSDateComponents()
		interval.day = 1
		var anchorComponents = calendar.dateComponents(Set([.day, .month, .year]), from: Date())
		anchorComponents.hour = 0
		let anchorDate = calendar.date(from: anchorComponents)
		
		let query = HKStatisticsCollectionQuery(quantityType: HKObjectType.quantityType(forIdentifier: type)!,
		                                        quantitySamplePredicate: nil,
		                                        options: .cumulativeSum,
		                                        anchorDate: anchorDate!,
		                                        intervalComponents: interval as DateComponents)
		query.initialResultsHandler = {
			query, results, error in
			if error != nil {
				completion(error, [], [])
			} else {
				let endDate = Date()
				let startDate = calendar.date(byAdding: .day, value: -daysBack, to: endDate)
				var dates = [Date]()
				var values = [Int]()
				results?.enumerateStatistics(from: startDate!,to: endDate, with: {
					result, stop in
					if let quantity = result.sumQuantity() {
						dates.append(result.startDate)
						if (type == .distanceWalkingRunning) {
							values.append(Int(quantity.doubleValue(for: HKUnit.meter())))
						} else if (type == .stepCount || type == .flightsClimbed) {
							values.append(Int(quantity.doubleValue(for: HKUnit.count())))
						} else {
							print("Identifier Type Not Supported")
							completion(nil, [], [])
							return
						}
					}
				})
				completion(nil, dates, values)
			}
			
		}
		
		self.healthKitStore.execute(query)
	}
	
	func goalForSteps(date: Date) -> Int {
		return WORKOUT_GOAL_DEFAULT_STEPS
	}
	
	func goalForDistance(date: Date) -> Int {
		return WORKOUT_GOAL_DEFAULT_DISTANCE
	}
	
	func goalForFlights(date: Date) -> Int {
		return WORKOUT_GOAL_DEFAULT_FLIGHTS
	}
}
