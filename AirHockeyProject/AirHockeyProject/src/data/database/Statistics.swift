//
//  Statistics.swift
//  AirHockeyProject
//
//  Created by divms on 3/26/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SQLite
public class Statistics {
    
    
    
    private class func getStatsByRow(row: [Binding?]) -> Stats {
        println("getting stats by row")
        var s: Stats = Stats()
        
        s.setId(row[0]! as? Int64)
        s.setGamesComplete(Int(row[1]! as Int64))
        
        s.setGamesExited(Int(row[2]! as Int64))
        s.setGamesWon(Int(row[3]! as Int64))
        s.setGamesLost(Int(row[4]! as Int64))
        s.setGamesTied(Int(row[5]! as Int64))
        
        s.setTimePlayed(Int(row[6]! as Int64))
        s.setGoalsScored(Int(row[7]! as Int64))
        s.setGoalsAgainst(Int(row[8]! as Int64))
        
        
        return s
        
        
    }
    
    class func getStatsById(i : Int64) -> Stats? {
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("select id, games_completed,games_exited,games_won,games_lost,games_tied,time_played,goals_scored,goals_against from stats where id=?",[i])
        
        for row in stmt.run() {
            var s : Stats = getStatsByRow(row)
            return s
        }
        
        return nil //means there were no stats with the given ID
    }
    
    // creates a new, blank set of stats. returns the ID given to the stats
    class func addNewStats() -> Int64? {
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("insert into stats (games_completed,games_exited,games_won,games_lost,games_tied,time_played,goals_scored,goals_against) VALUES (0,0,0,0,0,0,0,0)")
        
        stmt.run()
        
        return db.lastId
    }
    
    // given a stats object  with all fields set that is already present in the database, updates the
    // values stored in the database
    class func updateStats(s: Stats) {
        let db = Database(DatabaseManager.getDatabasePath())
        
        let stmt=db.prepare("update stats set games_completed=?,games_exited=?,games_won=?,games_lost=?,games_tied=?,time_played=?,goals_scored=?,goals_against=? where id=?", [s.getGamesComplete(),s.getGamesExited(),s.getGamesWon(),s.getGamesLost(),s.getGamesTied(),s.getTimePlayed(),s.getGoalsScored(),s.getId()])
        
        stmt.run()
        
        
    }
}