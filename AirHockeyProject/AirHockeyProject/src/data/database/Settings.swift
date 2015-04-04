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
        println("getting settings profile by row")
        var s: SettingsProfile = SettingsProfile()
        
        s.setId(row[0]! as? Int64)
        s.setFriction(row[1]! as? Double)
        s.setPlayerOnePaddleRadius(row[2]! as? Double)
        s.setPlayerTwoPaddleRadius(row[3]! as? Double)
        s.setPuckRadius(row[4]! as? Double)
        s.setTimeLimit(Int(row[5]! as Int64))
        s.setGoalLimit(Int(row[6]! as Int64))
        s.setAIDifficulty(Int(row[7]! as Int64))
        return s
        
       
    }
    
    class func getSettingsById(i : Int64) -> SettingsProfile? {
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("select id, friction, p1_paddle_radius,p2_paddle_radius,puck_radius,time,goals,ai_difficulty from settings where id=?",[i])
        
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
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("insert into settings (friction,p1_paddle_radius,p2_paddle_radius,puck_radius,time,goals,ai_difficulty) VALUES (?,?,?,?,?,?,?)",[s.getFriction(),s.getPlayerOnePaddleRadius(),s.getPlayerTwoPaddleRadius(),s.getPuckRadius(),s.getTimeLimit(),s.getGoalLimit(),s.getAIDifficultyAsNumber()])
        
        stmt.run()
        
        return db.lastId
    }
    
    // given a SettingsProfile with all fields set, updates what is saved in the database
    class func updateSettingsProfile(s : SettingsProfile) {
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("update settings set friction=?,p1_paddle_radius=?,p2_paddle_radius=?,puck_radius=?,time,goals=?,ai_difficulty=? where id=?",[s.getFriction(),s.getPlayerOnePaddleRadius(),s.getPlayerTwoPaddleRadius(),s.getPuckRadius(),s.getTimeLimit(),s.getGoalLimit(),s.getAIDifficultyAsNumber(),s.getId()])
        
        stmt.run()

    }
}