//
//  AIPlayer.swift
//  AirHockeyProject
//
//  Created by divms on 4/1/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public enum AIDifficulty : String {
    case Easy = "Easy"
    case Medium = "Medium"
    case Hard = "Hard"
    
    static func toColor(s : String) -> AIDifficulty? {
        if (s==Easy.rawValue) {
            return Easy
        } else if (s==Medium.rawValue) {
            return Medium
        } else if (s==Hard.rawValue) {
            return Hard
        }
        return nil
    }
    static func fromNumber(i : Int) -> AIDifficulty? {
        if (i==1) {
            return Easy
        } else if (i==2) {
            return Medium
        } else if i==3 {
            return Hard
        }
        return nil
    }
}


public class AIPlayer : Player  {
    private let WANDER_MIN_SPEED : CGFloat = 10.0
    private let WANDER_MAX_SPEED : CGFloat = 100.0
    private var difficulty : AIDifficulty
    
    private var defendPoint : CGPoint!
    private var puck : Puck!
    private var defendingHalf : CGRect!
    init(diff : AIDifficulty, i: Int, input: InputManager, p: Table) {
        difficulty = diff
        super.init(i: i, input: input, p: p)
        //TODO: This will all need to change if we start wanting to do moving goals or multiple goals
        let table = self.getPlayingTable()
        let defendingGoal = table.getDefendingGoal(self.getPlayerNumber())
        let line : (CGPoint,CGPoint) = defendingGoal.getGoalLine()
        let perpendicularSlope = Geometry.getPerpendicularSlope(line.0, p2: line.1)
        let centerPoint = CGPoint(x: (line.0.x+line.1.x)/2, y: (line.0.y+line.1.y)/2)
        let testPointOne = Geometry.getPointAtDistanceWithSlope(centerPoint, slope: perpendicularSlope, distance: 5)
        var distance : CGFloat = 50
        puck = table.getPuck()
        if (table.nodeAtPoint(testPointOne)===defendingGoal) {
            distance  = -distance
        }
        
        
        defendPoint = Geometry.getPointAtDistanceWithSlope(centerPoint, slope: perpendicularSlope, distance: distance)
        defendingHalf = table.getHalfForPlayer(self.getPlayerNumber())
    }
    
    //gets a completely random vector with a magnitude in the range of the given
    private func getWanderVector(minSpeed : CGFloat, maxSpeed : CGFloat) -> CGVector {
        let xMag = 1-(GameUtil.getRandomFloat() * 2)
        let yMag = 1-(GameUtil.getRandomFloat() * 2)
        let speed = GameUtil.getRandomFloatInRange(minSpeed,max: maxSpeed)
        let vector = Geometry.getVectorOfMagnitude(CGVector(dx: xMag, dy: yMag), b: speed)
        
        
        return vector
    }
    //returns a vector that tries to move the paddle back in front of the goal that it is defending
    private func getDefendVector() -> CGVector {
        
        
        return self.getPaddleVectorToPoint(defendPoint)
    }
    
    private func getStrikeVector() -> CGVector {
        return self.getPaddleVectorThroughPoint(puck.position)
    }
    
    private func trackPuckHorizontally() -> CGVector {
        let vector = self.getPaddleVectorToPoint(CGPoint(x: puck.position.x, y: self.getPaddle()!.position.y))
        
       
        
        return vector
    }
    
    
    //this is the entry point to the AI logic
    override func getMovementVector() -> CGVector? {
        let wanderVector = getWanderVector(WANDER_MIN_SPEED,maxSpeed: WANDER_MAX_SPEED)
        let puckOnThisHalf = defendingHalf.contains(puck.position)
        if (puckOnThisHalf) {
            return Geometry.getAverageVector([trackPuckHorizontally(),getStrikeVector(),getWanderVector(WANDER_MIN_SPEED, maxSpeed: WANDER_MAX_SPEED)])
        } else {
            return Geometry.getAverageVector([trackPuckHorizontally(),getDefendVector(),getWanderVector(WANDER_MIN_SPEED, maxSpeed: WANDER_MAX_SPEED)])
        }
        
        
    }
    
    override public func getMaxSpeed() -> CGFloat {
        if (difficulty==AIDifficulty.Easy) {
            return MAX_EASY_AI_PADDLE_SPEED
        } else if (difficulty==AIDifficulty.Medium) {
            return MAX_MEDIUM_AI_PADDLE_SPEED

        } else if (difficulty==AIDifficulty.Hard) {
            return MAX_HARD_AI_PADDLE_SPEED
        }
        return MAX_MEDIUM_AI_PADDLE_SPEED
    }
    
    override public func getMaxAcceleration() -> CGFloat {
        if (difficulty==AIDifficulty.Easy) {
            return MAX_EASY_AI_PADDLE_ACCEL
        } else if (difficulty==AIDifficulty.Medium) {
            return MAX_MEDIUM_AI_PADDLE_ACCEL
            
        } else if (difficulty==AIDifficulty.Hard) {
            return MAX_HARD_AI_PADDLE_ACCEL
        }
        return MAX_MEDIUM_AI_PADDLE_ACCEL
    }
    
    override func processPaddlePosition() {
        
    }
    
}