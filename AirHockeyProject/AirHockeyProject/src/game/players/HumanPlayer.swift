//
//  HumanPlayer.swift
//  AirHockeyProject
//
//  Created by divms on 3/29/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class HumanPlayer : Player {
    
    private var snapDistance : CGFloat = 12 // the distance from which the paddle will just snap to an input and stop
    
    // the stats profile associated with this user, as they were BEFORE THE START OF THE GAME!
    private var stats : Stats?
    private var tableHalf : CGRect
    init (i : Int, input : InputManager, p : GameScene, s : Stats?) {
        stats = s
        
        tableHalf = p.getPlayingTable().getHalfForPlayer(i)
        super.init(i: i, input: input, p: p)
    }
    
    override func getMovementVector() -> CGVector? {
        

        let inputManager = self.getInputManager()
        // move the puck to the mouse
        var vector : CGVector? = nil
        var input : CGPoint? = inputManager.getInputForPlayer(self.getPlayerNumber())
        let paddle = self.getPaddle()!
        if (!(input==nil)) {
            
            //paddles have no momentum unless they are simply released
            self.getPaddle()?.physicsBody!.velocity.dx = 0
            self.getPaddle()?.physicsBody!.velocity.dy = 0
            let boundRect = CGRect(origin: CGPoint(x: tableHalf.origin.x + paddle.size.width/2, y: tableHalf.origin.y + paddle.size.height/2), size: CGSize(width: tableHalf.width - paddle.size.width, height: tableHalf.height - paddle.size.height))
            let original = input!
            input = Geometry.getNearestPointInRect(boundRect, point: input!)

            
            
            return self.getPaddleVectorToPoint(input!)
            
            
        }
        
        return nil
    }
    
    override public func getMaxSpeed() -> CGFloat {
        return MAX_HUMAN_PADDLE_SPEED
        
    }
    
    override public func getMaxAcceleration() -> CGFloat {
        return MAX_HUMAN_PADDLE_ACCEL
    }
   
    
    public func handleGameConcluded(theirScore : Int, timePlayed : Int) {
        let myScore = self.score
        if (stats==nil) {
            return
        }
        var newStats = stats!.getCopy()
        
        newStats.setGoalsAgainst(stats!.getGoalsAgainst()!+theirScore)
        newStats.setGoalsScored(stats!.getGoalsScored()!+myScore)
        newStats.setTimePlayed(stats!.getTimePlayed()!+timePlayed)
        
        newStats.setGamesComplete(stats!.getGamesComplete()!+1)
        if (myScore==theirScore) {
            newStats.setGamesTied(stats!.getGamesTied()!+1)
        } else if (theirScore>myScore) {
            newStats.setGamesLost(stats!.getGamesLost()!+1)
        } else {
            newStats.setGamesWon(stats!.getGamesWon()!+1)
        }
        Statistics.updateStats(newStats)
    }
    
    // called when the user quits the game OR goes out to the home screen
    public func handleGameExited(theirScore : Int, timePlayed : Int) {
        let myScore = self.score

        if (stats==nil) {
            return
        }
        var newStats = stats!.getCopy()
        
        newStats.setGoalsAgainst(stats!.getGoalsAgainst()!+theirScore)
        newStats.setGoalsScored(stats!.getGoalsScored()!+myScore)
        newStats.setTimePlayed(stats!.getTimePlayed()!+timePlayed)
        
        newStats.setGamesExited(stats!.getGamesExited()!+1)
        Statistics.updateStats(newStats)
        

    }
    
    //called when the game is "resumed," which occurs if they go out to the home screen and then come back
    //this just reverts a user's stats to whatever they were before the game started, to be updated at the conclusion of the game
    public func handleGameResumed() {
        if (stats==nil) {
            return
        }
        Statistics.updateStats(stats!)

    }
    
    
    
    
}