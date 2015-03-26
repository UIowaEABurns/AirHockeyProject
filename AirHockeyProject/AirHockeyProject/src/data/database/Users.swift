//
//  Users.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SQLite
public class Users {
    
    
    class func createUser(u : User) {
        let timestamp=Util.getCurrentTimeMillis()
        let db = Database(DatabaseManager.getDatabasePath())
        
        
        let stmt=db.prepare("insert into users (username,first_name,last_name,setting_id,stats_id,last_login) VALUES (?,?,?,null,null,?)",[u.getUsername()!,u.getFirstName()!,u.getLastName()!,timestamp])
        stmt.run()
        
    }
    
    class func getUserByUsername(s: String) -> User? {
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("select username,first_name,last_name,setting_id,stats_id,last_login from users where username=?",[s])
        
        for row in stmt.run() {
            var u : User = User()
            u.setUsername(row[0]! as? String)
            u.setFirstName(row[1]! as? String)
            u.setLastName(row[2]! as? String)
            u.setLastLogin(Util.stringToLongInt((row[5]! as? String)!))
            
        
            println(u.getFirstName())
            return u
        }
        
        return nil //means there was no person
    }
    
    
    
}