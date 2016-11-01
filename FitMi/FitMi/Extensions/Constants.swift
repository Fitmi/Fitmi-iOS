//
//  Constants.swift
//  FitMi
//
//  Created by Jinghan Wang on 3/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import Foundation

let APPLICATION_ERROR_DOMAIN = "com.fitmi.FitMi"
let ERROR_CODE_HEALTH_DATA_NOT_AVAILABLE = 2

let SPRITE_HEALTH_DEFAULT: Int = 100
let SPRITE_STRENGTH_DEFAULT: Int = 100
let SPRITE_STAMINA_DEFAULT: Int = 100
let SPRITE_AGILITY_DEFAULT: Int = 100

let SPRITE_HEALTH_WEIGHT_TODAY: Double = 0.05

let WORKOUT_GOAL_DEFAULT_STEPS: Int = 5000
let WORKOUT_GOAL_DEFAULT_DISTANCE: Int = 2500
let WORKOUT_GOAL_DEFAULT_FLIGHTS: Int = 5

let WORKOUT_GOAL_PER_UNIT_BONUS_STEPS = 2500
let WORKOUT_GOAL_PER_UNIT_BONUS_DISTANCE = 1250
let WORKOUT_GOAL_PER_UNIT_BONUS_FLIGHTS = 2


let USER_DEFAULT_KEY_ONBOARD = "APP_ONBOARD_STATUS"
let USER_DEFAULT_KEY_ASSET_COUNT = "USER_DEFAULT_KEY_ASSET_COUNT"

let KEY_DAILY_EXTRA_EXP = "DailyExExp"
let KEY_DAILY_EXTRA_EXP_DATE = "DailyExExp-Date"

let GOAL_SET_DATE_STEPS = "GoalSetDateSteps"
let GOAL_SET_DATE_DISTANCE = "GoalSetDateDistance"
let GOAL_SET_DATE_FLIGHTS = "GoalSetDateFlights"

let GOAL_NEXT_STEPS = "GoalNextSteps"
let GOAL_NEXT_DISTANCE = "GoalNextDistance"
let GOAL_NEXT_FLIGHTS = "GoalNextFlights"

let GOAL_STEPS = "GoalSteps"
let GOAL_DISTANCE = "GoalDistance"
let GOAL_FLIGHTS = "GoalFlights"

let UPDATE_CHECK_URL_STAGING = "https://lvkev7x3m2.execute-api.ap-southeast-1.amazonaws.com/beta/updateCheck"
let UPDATE_CHECK_URL_PRODUCTION = "https://72s7ml6tyb.execute-api.ap-southeast-1.amazonaws.com/production/updateCheck"
let SPRITE_IMAGE_BASE_URL = "https://s3-ap-southeast-1.amazonaws.com/fitmi.sprites/"
let API_BASE_ENDPOINT = "https://fitmi.club/api"


//Watch
let CONNECTIVITY_KEY_WATCH_DATA = "WatchExerciseData"
let CONNECTIVITY_KEY_WATCH_DATA_LAST_SYNC_DATE = "CONNECTIVITY_KEY_WATCH_DATA_LAST_SYNC_DATE"
let PUSH_RETRY_MAX_COUNT = 5

enum WatchPersistentDataKey: String {
	case startTime = "PersistentDataKey.startTime"
	case endTime = "PersistentDataKey.endTime"
	case steps = "PersistentDataKey.steps"
	case meters = "PersistentDataKey.meters"
	case floors = "PersistentDataKey.floors"
}

enum AchievementId: String {
    case JOIN_MI = "achievement.fitmi.0"
}
