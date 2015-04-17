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
        }
        return nil
    }
    
}
public class SettingsProfile {
    
    
    
    
    private var id : Int64?
    private var friction : Double?
    private var playerOnePaddleRadius : Double?
    private var playerTwoPaddleRadius : Double?
    private var puckRadius : Double?
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
        return friction
    }
    public func setFriction(fric : Double?) {
        self.friction=fric
    }
    public func getPlayerOnePaddleRadius() -> Double? {
        return playerOnePaddleRadius
    }
    public func setPlayerOnePaddleRadius(r: Double?) {
        playerOnePaddleRadius=r
    }
    public func getPlayerTwoPaddleRadius() -> Double? {
        return playerTwoPaddleRadius
    }
    public func setPlayerTwoPaddleRadius(r: Double?) {
        playerTwoPaddleRadius=r
    }
    public func getPuckRadius() -> Double? {
        return puckRadius
    }
    public func setPuckRadius(r: Double?) {
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