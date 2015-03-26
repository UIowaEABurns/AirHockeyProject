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
    
    
    
}