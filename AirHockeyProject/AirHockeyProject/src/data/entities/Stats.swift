//
//  Stats.swift
//  AirHockeyProject
//
//  Created by divms on 3/24/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation

public class Stats {
    private var id : Int64?
    private var gamesComplete: Int?
    private var gamesExited : Int?
    private var gamesWon : Int?
    private var gamesLost : Int?
    private var gamesTied : Int?
    private var timePlayed : Int?
    private var goalsScored : Int?
    private var goalsAgainst : Int?
    init() {
        
    }
    
    public func getId() -> Int64? {
        return id
    }
    public func getGamesComplete() -> Int? {
        return gamesComplete
    }
    public func getGamesExited() -> Int? {
        return gamesExited
    }
    public func getGamesWon() -> Int? {
        return gamesWon
    }
    public func getGamesLost() -> Int? {
        return gamesLost
    }
    public func getGamesTied() -> Int? {
        return gamesTied
    }
    public func getTimePlayed() -> Int? {
        return timePlayed
    }
    public func getGoalsScored() -> Int? {
        return goalsScored
    }
    public func getGoalsAgainst() -> Int? {
        return goalsAgainst
    }
    
    
    
    
    public func setId(i : Int64?) {
        self.id=i
    }
    public func setGamesComplete(i : Int?) {
        self.gamesComplete=i
    }
    public func setGamesExited(i : Int?) {
        self.gamesExited=i
    }
    public func setGamesWon(i : Int?) {
        self.gamesWon=i
    }
    public func setGamesLost(i : Int?) {
        self.gamesLost=i
    }
    public func setGamesTied(i : Int?) {
        self.gamesTied=i
    }
    
    public func setTimePlayed(i : Int?) {
        self.timePlayed=i
    }
    
    public func setGoalsScored(i : Int?) {
        self.goalsScored=i
    }
    public func setGoalsAgainst(i : Int?) {
        self.goalsAgainst=i
    }
    
}