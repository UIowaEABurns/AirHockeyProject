//
//  Constants.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public var maxHumanPaddleSpeed : CGFloat=1100.0
public var maxHumanPaddleAcceleration : CGFloat = 1100.0
public var paddlePuckMassRatio : CGFloat = 3 // how much more should the paddles weigh as compared to the puck


public var gameFont : String = "Chalkduster"


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
        
        return s
    }
    
    
}