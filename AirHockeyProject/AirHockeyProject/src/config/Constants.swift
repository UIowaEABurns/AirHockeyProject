//
//  Constants.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

//size constants for the game
public var TABLE_WIDTH_FRACTION : CGFloat = 0.8 // how tall / wide should the table be compared to the screen
public var TABLE_HEIGHT_FRACTION : CGFloat = 0.9
public var SCORE_DISPLAY_PADDING : CGFloat = 100 // how many points away from the timer should we place the scores?

//display constants for the game
public var OVERLAY_COLOR : SKColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)

//physical constants for the game
public var MAX_HUMAN_PADDLE_SPEED : CGFloat=1000.0
public var MAX_HUMAN_PADDLE_ACCEL : CGFloat = 1000.0

public var MAX_EASY_AI_PADDLE_SPEED : CGFloat = 600.0
public var MAX_EASY_AI_PADDLE_ACCEL : CGFloat = 600.0
public var MAX_MEDIUM_AI_PADDLE_SPEED : CGFloat = 800.0
public var MAX_MEDIUM_AI_PADDLE_ACCEL : CGFloat = 800.0
public var MAX_HARD_AI_PADDLE_SPEED : CGFloat = 1000.0
public var MAX_HARD_AI_PADDLE_ACCEL : CGFloat = 1000.0

public var MAX_PUCK_SPEED : CGFloat = 1000.0

public var paddlePuckMassRatio : CGFloat = 3 // how much more should the paddles weigh as compared to the puck
public var TABLE_BARRIER_RESTITUTION : CGFloat = 0.01 // affects how "bouncy" the invisible barrier in the middle of the table is

//node name constants
public var GOAL_NAME = "goal"
public var PUCK_NAME = "puck"
public var TABLE_EFFECT_OVERLAY_NAME = "effectoverlay"


//these are global system settings
public var BG_MUSIC_VOLUME = 1.0
public var FX_VOLUME  = 1.0




public class AirHockeyConstants {
    
   
    
    
    //TODO: Localizing all default settings for the game in this function! Do needed tweaking in here!
    public class func getDefaultSettings() -> SettingsProfile {
       var s: SettingsProfile = SettingsProfile()
        s.setFriction(0.05)
        
        
        //These are ratios of board width to paddle radius
        s.setPlayerOnePaddleRadius(0.04)
        s.setPlayerTwoPaddleRadius(0.04)
        s.setPuckRadius(0.03)
        s.setAIDifficulty(2)
        s.setTimeLimit(420) // seven minutes
        s.setGoalLimit(7)
        s.setPlayerOnePaddleColor(PaddleColor.Red)
        s.setPlayerTwoPaddleColor(PaddleColor.Blue)
        return s
    }
    
    

    
    
}