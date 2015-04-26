//
//  SettingsProfile.swift
//  AirHockeyProject
//
//  Created by divms on 3/24/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public enum PaddleColor : Int {
    case Red = 0
    case Blue = 1
    case Green = 2
    case Yellow = 3
    case Black = 4
    case White = 5
    static func allValues() -> [PaddleColor] {
        return [Red,Blue,Green]
    }
    
    static func intToPaddleColor(i : Int) -> PaddleColor? {
        for color in allValues() {
            if color.rawValue==i {
                return color
            }
        }
        return nil
    }
    
    func getAsColor() -> SKColor? {
        if (self==Red) {
            return SKColor.redColor()
        } else if (self==Blue) {
            return SKColor.blueColor()
        } else if (self==Green) {
            return SKColor.greenColor()
        } else if (self == Yellow) {
            return SKColor.yellowColor()
        } else if (self == Black) {
            return SKColor.blackColor()
        }else if (self==White) {
            return SKColor.whiteColor()
        }
        return nil
    }
    
}

public enum GameObjectSize : Int {
    case VerySmall = 0
    case Small = 1
    case Normal = 2
    case Large = 3
    case VeryLarge = 4
    static func allValues() -> [GameObjectSize] {
        return [VerySmall,Small,Normal,Large,VeryLarge]
    }
    
    static func intToSize(i : Int) -> GameObjectSize? {
        for color in allValues() {
            if color.rawValue==i {
                return color
            }
        }
        return nil
    }
    func getPuckSize() -> Double {
        if self==VerySmall {
            return DEFAULT_PUCK_RADIUS / 2

        } else if self==Small {
            return DEFAULT_PUCK_RADIUS / 1.5
        } else if self==Normal {
            return DEFAULT_PUCK_RADIUS
        } else if self==Large {
            return DEFAULT_PUCK_RADIUS * 1.5

        } else if self==VeryLarge {
            return DEFAULT_PUCK_RADIUS * 2

        }
        return DEFAULT_PUCK_RADIUS
    }
    
    func getPaddleSize() -> Double {
        if self==VerySmall {
            return DEFAULT_PADDLE_RADIUS / 2

        } else if self==Small {
            return DEFAULT_PADDLE_RADIUS / 1.5

        } else if self==Normal {
            return DEFAULT_PADDLE_RADIUS
        } else if self==Large {
            return DEFAULT_PADDLE_RADIUS * 1.5

        } else if self==VeryLarge {
            return DEFAULT_PADDLE_RADIUS * 2

        }
        return DEFAULT_PADDLE_RADIUS
    }
    
    func getFriction() -> Double {
        if self==VerySmall {
            return 0
            
        } else if self==Small {
            return DEFAULT_FRICTION
            
        } else if self==Normal {
            return DEFAULT_FRICTION * 3
        } else if self==Large {
            return DEFAULT_FRICTION * 5
            
        } else if self==VeryLarge {
            return DEFAULT_FRICTION * 10
            
        }
        return DEFAULT_FRICTION
    }
    
}




public class SettingsProfile {
    
    
    
    
    private var id : Int64?
    private var friction : GameObjectSize?
    private var playerOnePaddleRadius : GameObjectSize?
    private var playerTwoPaddleRadius : GameObjectSize?
    private var puckRadius : GameObjectSize?
    private var timeLimit : Int?
    private var goalLimit : Int? // null if they are infinite
    private var aiDifficulty : Int?
    private var playerOnePaddleColor : PaddleColor?
    private var playerTwoPaddleColor : PaddleColor?
    private var themeName : String?
    private var powerupsEnabled : Bool?
    init() {
        
    }
    
    public func getId() -> Int64? {
        return id;
    }
    public func setId(id : Int64?) {
        self.id=id
    }
    public func getFriction() -> Double? {
        if friction == nil {
            return nil
        
        }
        return friction!.getFriction()
    }
    
    public func getFrictionValue() -> Int? {
        if friction == nil {
            return nil
            
        }
        return friction!.rawValue
    }
    
    
    
    public func setFriction(fric : GameObjectSize) {
        self.friction=fric
    }
    
    public func getPlayerOnePaddleRadiusValue() -> Int? {
        if (playerOnePaddleRadius == nil) {
            return nil
        }
        return playerOnePaddleRadius!.rawValue
    }
    public func getPlayerTwoPaddleRadiusValue() -> Int? {
        if (playerTwoPaddleRadius == nil) {
            return nil
        }
        return playerTwoPaddleRadius!.rawValue
    }
    public func getPuckRadiusValue() -> Int? {
        if puckRadius == nil {
            return nil
        }
        return puckRadius!.rawValue
    }
    
    public func getPlayerOnePaddleRadius() -> Double? {
        if (playerOnePaddleRadius == nil) {
            return nil
        }
        return playerOnePaddleRadius!.getPaddleSize()
    }
    public func setPlayerOnePaddleRadius(r: GameObjectSize) {
        playerOnePaddleRadius=r
    }
    public func getPlayerTwoPaddleRadius() -> Double? {
        if (playerTwoPaddleRadius == nil) {
            return nil
        }
        return playerTwoPaddleRadius!.getPaddleSize()
    }
    public func setPlayerTwoPaddleRadius(r: GameObjectSize) {
        
        playerTwoPaddleRadius=r
    }
    public func getPuckRadius() -> Double? {
        if puckRadius == nil {
            return nil
        }
        return puckRadius!.getPuckSize()
    }
    public func setPuckRadius(r: GameObjectSize) {
        puckRadius=r
    }
    public func getTimeLimit() -> Int? {
        return timeLimit
    }
    public func setTimeLimit(t : Int?) {
        timeLimit=t
    }
    public func getGoalLimit() -> Int? {
        return goalLimit
    }
    public func setGoalLimit(g: Int?) {
        goalLimit=g
    }
    public func getAIDifficulty() -> AIDifficulty? {
        return AIDifficulty.fromNumber(aiDifficulty!)
    }
    public func getAIDifficultyAsNumber() -> Int? {
        return aiDifficulty
    }
    public func setAIDifficulty(d: Int? ){
        aiDifficulty=d
    }
    
    public func setPlayerOnePaddleColor(color : PaddleColor) {
        playerOnePaddleColor = color
    }
    
    public func setPlayerTwoPaddleColor(color : PaddleColor) {
        playerTwoPaddleColor = color
    }
    
    public func setPlayerOnePaddleColor(colorNumber : Int) {
        playerOnePaddleColor = PaddleColor.intToPaddleColor(colorNumber)
    }
    
    public func setPlayerTwoPaddleColor(colorNumber : Int) {
        playerTwoPaddleColor = PaddleColor.intToPaddleColor(colorNumber)
    }
    
    public func getPlayerOnePaddleColorNumber() -> Int? {
        if (playerOnePaddleColor==nil) {
            return nil
        }
        return playerOnePaddleColor!.rawValue
    }
    
    public func getPlayerTwoPaddleColorNumber() -> Int? {
        if (playerTwoPaddleColor==nil) {
            return nil
        }
        return playerTwoPaddleColor!.rawValue
    }
    
    
    public func getPlayerOnePaddleColor() -> SKColor? {
        if playerOnePaddleColor==nil {
            return nil
        }
        return playerOnePaddleColor!.getAsColor()
    }
    
    public func getPlayerTwoPaddleColor() -> SKColor? {
        if playerOnePaddleColor==nil {
            return nil
        }
        return playerTwoPaddleColor!.getAsColor()
    }
    
    public func setThemeName(s : String) {
        themeName = s
    }
    public func getThemeName() -> String? {
        return themeName
    }
    public func setPowerupsEnabled(b : Bool) {
        powerupsEnabled = b
    }
    public func arePowerupsEnabled() -> Bool? {
        return powerupsEnabled
    }
}