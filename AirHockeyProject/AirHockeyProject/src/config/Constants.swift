//
//  Constants.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public var maxHumanPaddleSpeed : CGFloat=400.0
public var maxHumanPaddleAcceleration : CGFloat = 100.0

public class AirHockeyConstants {
    
   
    
    
    //TODO: Localizing all default settings for the game in this function! Do needed tweaking in here!
    public class func getDefaultSettings() -> SettingsProfile {
       var s: SettingsProfile = SettingsProfile()
        s.setFriction(0.05)
        s.setPlayerOnePaddleRadius(13.0)
        s.setPlayerTwoPaddleRadius(13.0)
        s.setPuckRadius(10.0)
        s.setAIDifficulty(2)
        s.setTimeLimit(420) // seven minutes
        s.setGoalLimit(7)
        
        return s
    }
}