//
//  FMSprite.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation
import RealmSwift

class FMSprite: Object {
	
	dynamic var identifier: String = UUID().uuidString
	dynamic var name: String = "Default"
	dynamic var mood: Int = 100
	dynamic var birthday:Date = Date()
	
	dynamic var skillInUse: FMSKill!
	dynamic var appearanceIdentifier: String = ""
	let skills = List<FMSKill>()
	let actions = List<FMAction>()
	
	let states = List<FMSpriteState>()
	let exercises = List<FMExerciseRecord>()
	
	override static func indexedProperties() -> [String] {
		return ["identifier"]
	}

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
