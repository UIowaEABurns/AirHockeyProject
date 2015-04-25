//
//  User.swift
//  AirHockeyProject
//
//  Created by divms on 3/24/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation


public class User {
    
    private var firstName : String?
    private var lastName : String?
    private var username : String?
    private var lastLogin : Int64? // this is a timestamp in Unix time (milliseconds since the epoch)
    private var settings : SettingsProfile?
    private var stats : Stats?
    init() {
        
    }
    
    
    public func setFirstName(name: String?) {
        self.firstName=name
    }
    public func setLastName(name: String?) {
        self.lastName=name
    }
    public func setUsername(name: String?) {
        self.username=name
    }
    public func setLastLogin(milli: Int64?) {
        lastLogin=milli;
    }
    
    public func getFirstName() -> String? {
        return firstName
    }
    public func getLastName() -> String? {
        return lastName
    }
    public func getUsername() -> String? {
        return username
    }
    public func getLastLogin() -> Int64? {
        return lastLogin
    }
    public func getSettingsProfile() -> SettingsProfile? {
        return settings
    }
    public func setSettingsProfile(s: SettingsProfile?) {
        settings=s
    }
    
    public func getStats() -> Stats? {
        return stats
    }
    
    public func setStats(s : Stats?) {
        self.stats=s
    }
    
     private var rows = ["Win %","Games Completed", "Games Won", "Games Lost", "Games Tied","Games Aborted", "Total Playtime", "Goals Scored", "Goals Allowed"]
    
    public func getSortValueForIndex(index : Int) -> Float? {
        let s = stats!
        if index==0 {
            return s.getWinPercent()
        } else if index==1 {
            return Float(s.getGamesComplete()!)
        } else if index==2 {
            return Float(s.getGamesWon()!)
        } else if index==3 {
            return Float(s.getGamesLost()!)
        } else if index==4 {
            return Float(s.getGamesTied()!)
        } else if index==5 {
            return Float(s.getGamesExited()!)
        } else if index==6 {
            return Float(s.getTimePlayed()!)
        } else if index==7 {
            return Float(s.getGoalsScored()!)
        } else if index==8 {
            return Float(s.getGoalsAgainst()!)
        }
        return s.getWinPercent()
    }
    
    
}