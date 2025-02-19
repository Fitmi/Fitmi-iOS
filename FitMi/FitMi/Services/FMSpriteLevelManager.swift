//
//  FMSpriteLevelManager.swift
//  FitMi
//
//  Created by Jinghan Wang on 9/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMSpriteLevelManager: NSObject {
	static let sharedManager = FMSpriteLevelManager()

	func skillSlotCountForLevel(level: Int) -> Int {
		if level < 2 {
			return 1
		} else if level < 12 {
			return 2
		} else {
			return 3
		}
	}
	
	func healthLimitForLevel(level: Int) -> Int {
		return 200 + level * 50
	}
	
	func experienceLimitForLevel(level: Int) -> Int {
		return (200 + 50 * level) * (level + 1)
	}
	
	func levelForExp(exp: Int) -> Int {
		var level = 0
		
		while(exp > self.experienceLimitForLevel(level: level)) {
			level += 1
		}
		
		return level
	}
	
}
