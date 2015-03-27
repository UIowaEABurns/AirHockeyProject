//
//  Constants.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation


public class AirHockeyConstants {
    
    //TODO: Localizing all default settings for the game in this function! Do needed tweaking in here!
    public class func getDefaultSettings() -> SettingsProfile {
       var s: SettingsProfile = SettingsProfile()
        s.setFriction(0.05)
        s.setPlayerOnePaddleRadius(5.0)
        s.setPlayerTwoPaddleRadius(5.0)
        s.setPuckRadius(4.0)
        s.setAIDifficulty(2)
        s.setTimeLimit(420) // seven minutes
        s.setGoalLimit(7)
        
        return s
    }
}