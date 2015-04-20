//
//  Constants.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

let defaults=NSUserDefaults.standardUserDefaults()

//size constants for the game
public var TABLE_WIDTH_FRACTION : CGFloat = 0.8 // how tall / wide should the table be compared to the screen
public var TABLE_HEIGHT_FRACTION : CGFloat = 0.96
public var GOAL_WIDTH_RATIO : CGFloat = 0.40
public var SCORE_DISPLAY_PADDING : CGFloat = 100 // how many points away from the timer should we place the scores?

//display constants for the game
public var OVERLAY_COLOR : SKColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)

//physical constants for the game
public var MAX_HUMAN_PADDLE_SPEED : CGFloat=3000.0
public var MAX_HUMAN_PADDLE_ACCEL : CGFloat = 3000.0

public var MAX_EASY_AI_PADDLE_SPEED : CGFloat = 600.0
public var MAX_EASY_AI_PADDLE_ACCEL : CGFloat = 600.0
public var MAX_MEDIUM_AI_PADDLE_SPEED : CGFloat = 800.0
public var MAX_MEDIUM_AI_PADDLE_ACCEL : CGFloat = 800.0
public var MAX_HARD_AI_PADDLE_SPEED : CGFloat = 1300.0
public var MAX_HARD_AI_PADDLE_ACCEL : CGFloat = 1300.0

public var MAX_PUCK_SPEED : CGFloat = 2000.0

public var paddlePuckMassRatio : CGFloat = 6 // how much more should the paddles weigh as compared to the puck
public var TABLE_BARRIER_RESTITUTION : CGFloat = 0.01 // affects how "bouncy" the invisible barrier in the middle of the table is

//node name constants
public var GOAL_NAME = "goal"
public var PUCK_NAME = "puck"
public var TABLE_EFFECT_OVERLAY_NAME = "effectoverlay"


//these are global system settings
public var BG_MUSIC_VOLUME : Float = 1.0
public var FX_VOLUME : Float  = 1.0
public var muted : Bool = false



public class AirHockeyConstants {
    
   
    
    
    //TODO: Localizing all default settings for the game in this function! Do needed tweaking in here!
    public class func getDefaultSettings() -> SettingsProfile {
       var s: SettingsProfile = SettingsProfile()
        s.setFriction(0.05)
        
        
        //These are ratios of board width to paddle radius
        s.setPlayerOnePaddleRadius(0.06)
        s.setPlayerTwoPaddleRadius(0.06)
        s.setPuckRadius(0.03)
        s.setAIDifficulty(2)
        s.setTimeLimit(420) // seven minutes
        s.setGoalLimit(7)
        s.setPlayerOnePaddleColor(PaddleColor.Red)
        s.setPlayerTwoPaddleColor(PaddleColor.Blue)
        s.setThemeName("ice")
        s.setPowerupsEnabled(true)
        return s
    }
    
    // writes BG_MUSIC_VOLUME and FX_VOLUME to NSUserDefaults

    public class func saveVolumeSettings() {
        defaults.setObject(BG_MUSIC_VOLUME, forKey: "bgvolume")
        defaults.setObject(FX_VOLUME, forKey: "fxvolume")
    }
    
    // populates BG_MUSIC_VOLUME and FX_VOLUME
    public class func loadVolumeSettings() {
        
        if let temp: AnyObject = defaults.objectForKey("bgvolume") {
            BG_MUSIC_VOLUME = defaults.floatForKey("bgvolume")

        }
        if let temp : AnyObject = defaults.objectForKey("fxvolume") {
            FX_VOLUME = defaults.floatForKey("fxvolume")
        }
    }
    
    public class func saveMuteSetting() {
        defaults.setObject(muted, forKey: "mutedsetting")
    }
    
    public class func loadMuteSetting() {
        if let temp: AnyObject = defaults.objectForKey("mutedsetting") {
            muted = defaults.boolForKey("mutedsetting")
        }
    }
    
    
}