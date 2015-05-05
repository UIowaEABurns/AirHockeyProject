//
//  Settings.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SQLite

public class Settings {
    
    

    private class func getSettingsProfileByRow(row: [Binding?]) -> SettingsProfile {
        var s: SettingsProfile = SettingsProfile()
        
        s.setId(row[0]! as? Int64)
        
        let friction  = Int(row[1]! as! Int64)
        
        s.setFriction(GameObjectSize.intToSize(friction)!)
        let p1PaddleSize = Int(row[2]! as! Int64)
        let p2PaddleSize = Int(row[3]! as! Int64)
        
        s.setPlayerOnePaddleRadius(GameObjectSize.intToSize(p1PaddleSize)!)
        s.setPlayerTwoPaddleRadius(GameObjectSize.intToSize(p2PaddleSize)!)
        let p1PaddleColor: Int = Int((row[4] as! Int64))
        let p2PaddleColor : Int = Int((row[5] as! Int64))
        s.setPlayerOnePaddleColor(PaddleColor.intToPaddleColor(p1PaddleColor)!)
        s.setPlayerTwoPaddleColor(PaddleColor.intToPaddleColor(p2PaddleColor)!)
        
        
        let puckSize = Int(row[6]! as! Int64)
        
        s.setPuckRadius(GameObjectSize.intToSize(puckSize)!)
        s.setTimeLimit(Int(row[7]! as! Int64))
        s.setGoalLimit(Int(row[8]! as! Int64))
        s.setAIDifficulty(Int(row[9]! as! Int64))
        s.setThemeName(row[10]! as! String)
        let x = row[11]! as! Int64
        if (x == 1) {
            s.setPowerupsEnabled(true)
        } else {
            s.setPowerupsEnabled(false)
        }
        return s
        
       
    }
    
    class func getSettingsById(i : Int64) -> SettingsProfile? {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        
        let stmt=db.prepare("select id, friction, p1_paddle_radius,p2_paddle_radius,p1_paddle_color,p2_paddle_color,puck_radius,time,goals,ai_difficulty,theme_name, powerups_enabled from settings where id=?",[i])
        
        for row in stmt.run() {
            var s : SettingsProfile = getSettingsProfileByRow(row)
            return s
        }
        
        return nil //means there was no profile with the given ID
    }
    
    class func addNewSettingsProfile() -> Int64? {
        return addNewSettingsProfile(AirHockeyConstants.getDefaultSettings())
    }
    
    class func addNewSettingsProfile(s : SettingsProfile) -> Int64? {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        var powerups = 0
        if (s.arePowerupsEnabled() != nil && s.arePowerupsEnabled()!) {
            powerups = 1
        }
        let stmt=db.prepare("insert into settings (friction,p1_paddle_radius,p2_paddle_radius,p1_paddle_color,p2_paddle_color,puck_radius,time,goals,ai_difficulty,theme_name,powerups_enabled) VALUES (?,?,?,?,?,?,?,?,?,?,?)",[s.getFrictionValue(),s.getPlayerOnePaddleRadiusValue(),s.getPlayerTwoPaddleRadiusValue(),s.getPlayerOnePaddleColorNumber(),s.getPlayerTwoPaddleColorNumber(), s.getPuckRadiusValue(),s.getTimeLimit(),s.getGoalLimit(),s.getAIDifficultyAsNumber(),s.getThemeName(), powerups])
        
        stmt.run()
        
        return db.lastInsertRowid
    }
    
    // given a SettingsProfile with all fields set, updates what is saved in the database
    class func updateSettingsProfile(s : SettingsProfile) {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        var powerups = 0
        if (s.arePowerupsEnabled() != nil && s.arePowerupsEnabled()!) {
            powerups = 1
        }
        let stmt=db.prepare("update settings set friction=?,p1_paddle_radius=?,p2_paddle_radius=?,p1_paddle_color=?,p2_paddle_color=?,puck_radius=?,time=?,goals=?,ai_difficulty=?, theme_name=?, powerups_enabled=? where id=?",[s.getFrictionValue(),s.getPlayerOnePaddleRadiusValue(),s.getPlayerTwoPaddleRadiusValue(),s.getPlayerOnePaddleColorNumber(),s.getPlayerTwoPaddleColorNumber(), s.getPuckRadiusValue(),s.getTimeLimit(),s.getGoalLimit(),s.getAIDifficultyAsNumber(),s.getThemeName(),powerups,s.getId()])
        
        stmt.run()

    }
    
    // given a SettingsProfile with all fields set, updates what is saved in the database
    class func updateSettingsProfileTheme(s : SettingsProfile) {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        
        let stmt=db.prepare("update settings set theme_name=? where id=?",[s.getThemeName(),s.getId()])
        
        stmt.run()
        
    }

}