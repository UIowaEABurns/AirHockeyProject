//
//  Users.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SQLite

var userOneUsername : String?
var userTwoUsername : String?

public class Users {
    
    

        /*Adds a new user to the database. Also gives them a new, default set of settings and stats. Settings and stats
        the user object has are not respected!*/

    class func createUser(u : User) {
        let timestamp=Util.getCurrentTimeMillis()
        let db = Database(DatabaseManager.getDatabasePath() as String)
        let settingId=Settings.addNewSettingsProfile()
        let statsId=Statistics.addNewStats()
        println("settings id = ")
        println(settingId)
        println("stats id = ")
        println(statsId)
        let stmt=db.prepare("insert into users (username,first_name,last_name,setting_id,stats_id,last_login) VALUES (?,?,?,?,?,?)",[u.getUsername()!,u.getFirstName()!,u.getLastName()!,settingId!,statsId!,timestamp])
        stmt.run()
        
        println(stmt.failed)
        
    }
   
    private class func getUserByRow(row: [Binding?]) -> User {
        var u: User = User()
        
        u.setUsername(row[0]! as? String)
        u.setFirstName(row[1]! as? String)
        u.setLastName(row[2]! as? String)
        
        let settingId=row[3] as? Int64
        println("found this settingId")
        println(settingId)
        if (settingId==nil) {
            u.setSettingsProfile(nil)
        } else {
            u.setSettingsProfile(Settings.getSettingsById(settingId!))
           
        }
        
        let statsId=row[4] as? Int64
        if (statsId==nil) {
            u.setStats(nil)
            
        } else {
            u.setStats(Statistics.getStatsById(statsId!))
            println("got stats")
            println(u.getStats()!.getGamesLost())
        }
        
        
        
        u.setLastLogin(row[5]! as? Int64)
        
        return u
    }
    // deletes the user with the given username from the database
    class func deleteUserByUsername(s: String) {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        let stmt=db.prepare("delete from users where username=?",[s])
        stmt.run()
        
    }
    
    
    class func getUserByUsername(s: String) -> User? {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        
        let stmt=db.prepare("select username,first_name,last_name,setting_id,stats_id,last_login from users where username=?",[s])
        
        for row in stmt.run() {
            var u : User = getUserByRow(row)
           
            
        
            println(u.getFirstName())
            return u
        }
        
        return nil //means there was no person with the given username
    }
    
    class func getAllUsers(s: String) -> [User] {
        let db = Database(DatabaseManager.getDatabasePath() as String)
        
        let stmt=db.prepare("select username,first_name,last_name,setting_id,stats_id,last_login from users")
        var users : [User] = []
        for row in stmt.run() {
            var u : User = getUserByRow(row)
            
            users.append(u)
        }
        
        return users
    }
    
    
    class func saveUserLogins() {
        defaults.setObject(userOneUsername, forKey: "useronelogin")
        defaults.setObject(userTwoUsername, forKey: "usertwologin")
    }
    
    class func loadUserLogins() {
        if let temp: AnyObject = defaults.objectForKey("useronelogin") {
            userOneUsername = defaults.stringForKey("useronelogin")
            
        } else {
            userOneUsername = nil
        }
        if let temp : AnyObject = defaults.objectForKey("usertwologin") {
            userTwoUsername = defaults.stringForKey("usertwologin")
        } else {
            userTwoUsername = nil
        }
    }
    
    //true to log player one in, false to log player 2 in
    class func login(user : User, playerOne : Bool) -> Bool {
        
        var success : Bool = true
        let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
        dispatch_sync(lockQueue) {
            //user is already logged in
            if (userOneUsername == user.getUsername() || userTwoUsername == user.getUsername()) {
                success = false
            } else if user.getUsername() == nil {
                success = false
            } else if (playerOne && userOneUsername != nil) {
                success = false
            } else if ( !playerOne && userTwoUsername != nil) {
                success = false
            } else {
                if playerOne {
                    userOneUsername = user.getUsername()!
                } else {
                    userTwoUsername = user.getUsername()!
                }
                self.saveUserLogins()
            }
        }
        
        
        return success
    }
    
    class func logout(playerOne : Bool) {
        if playerOne {
            userOneUsername = nil
        } else {
            userTwoUsername = nil
        }
        saveUserLogins()
    }
}