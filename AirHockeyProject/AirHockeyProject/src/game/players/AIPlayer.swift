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
    
    static func toDifficulty(s : String) -> AIDifficulty? {
        if (s==Easy.rawValue) {
            return Easy
        } else if (s==Medium.rawValue) {
            return Medium
        } else if (s==Hard.rawValue) {
            return Hard
        }
        return nil
    }
    
    static func toNumber(diff : AIDifficulty) -> Int {
        if diff==AIDifficulty.Easy {
            return 1
        } else if diff==AIDifficulty.Medium {
            return 2
        } else {
            return 3
        }
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

private enum AIState {
    case Defend // stay near the front of the goal
    case Strike // hit the puck ASAP
    case Agress // actively block the front of the court
    case Align // try to set up for a strike
    case Powerup // try to obtain a powerup
    case Center // move to goal
}


public class AIPlayer : Player  {
    private let WANDER_MIN_SPEED : CGFloat = 10.0
    private let WANDER_MAX_SPEED : CGFloat = 200.0
    private var difficulty : AIDifficulty
    
    private var state : AIState
    private var defendPoint : CGPoint! // this is the optimal defensive position in front of the goal.
    private var currentDefendPoint : CGPoint! // this is a random point somewhere near the defendPoint
    private var switchDefendPointOdds : CGFloat = 0.03
    
    private var reactionCount : Int = 0
    private var minReactionFrames = 15
    private var maxReactionFrames = 60
    
    private var touchCounter : Int = 0
    private var unlockCounter : Int = 0
    private var locked: Bool = false
    private var puck : Puck!
    private var defendingHalf : CGRect!
    init(diff : AIDifficulty, i: Int, input: InputManager, p: GameScene) {
        difficulty = diff
        
        state = AIState.Defend
        super.init(i: i, input: input, p: p)
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
        currentDefendPoint = defendPoint
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
        
        if (GameUtil.getRandomFloat() < switchDefendPointOdds) {
            currentDefendPoint = getRandomPointFromPoint(defendPoint)
        }
        
        return self.getPaddleVectorToPoint(currentDefendPoint,speedMult: 0.15)
    }
    
    private func getStrikeVector() -> CGVector {
        //var puckPoint = getRandomPointFromPoint(puck.position)
        return self.getPaddleVectorThroughPoint(puck.position)
    }
    private func getPowerupVector() -> CGVector? {
        if let powerup = self.scene.getPowerup() {
            
            return self.getPaddleVectorThroughPoint(powerup.position)
        }
        
        return nil
    }
    
    private func getRandomPointFromPoint(point : CGPoint) -> CGPoint {
        let xVar = GameUtil.getRandomFloatInRange(-200, max: 200)
        let yVar =  GameUtil.getRandomFloatInRange(-20, max: 20)
        return CGPoint(x: point.x+xVar, y: point.y + yVar)
    }
    
    private func trackPuckHorizontally() -> CGVector {
        let vector = self.getPaddleVectorToPoint(CGPoint(x: puck.position.x, y: self.getPaddle()!.position.y))
        
       
        return vector
    }
    
    
    //this is the entry point to the AI logic
    override func getMovementVector() -> CGVector? {
        if locked {
            unlockCounter = unlockCounter + 1
            if unlockCounter > 30 {
                unlockCounter = 0
                locked = false
                touchCounter = 0
            }
        }
        setState()
        if (self.state == AIState.Strike) {
            return Geometry.getAverageVector([trackPuckHorizontally(),getStrikeVector()])
        } else if (self.state == AIState.Defend) {
            return Geometry.getAverageVector([trackPuckHorizontally(),getDefendVector()])
        } else if (self.state == AIState.Center) {
            return getDefendVector()
        }
        else if (self.state == AIState.Powerup) {
            let powerVector = getPowerupVector()
            if (powerVector != nil) {
                return Geometry.getAverageVector([powerVector!])

            }
        }
        
        
        
        
        return nil
    }
    
    //try to figure out what state to be in during this frame
    private func setState() {
        let puckOnThisHalf = defendingHalf.contains(puck.position)
        if (!puckOnThisHalf) {
            locked = false
            touchCounter = 0
            unlockCounter = 0
        }
        var newState = self.state
        if locked {
            self.state = AIState.Center
            return
        }
        if (puckOnThisHalf) {
            if (puck.isIntangible()) {
                self.state = AIState.Defend // no reaction time for this
                newState = AIState.Defend
            } else {
                newState = AIState.Strike
            }
        } else {
            touchCounter = 0
            let powerup = self.scene.getPowerup()
        
            if (powerup != nil && powerup!.parent != nil) {
                newState = AIState.Powerup
            } else {
                newState = AIState.Defend

            }
        }
        
        
        if ( newState != self.state ) {
            if (canReact()) {
                self.state = newState
            }
        }
        
    }
    
    //figures out if we can react (defined as changing states) on this frame
    private func canReact() -> Bool {
        reactionCount = reactionCount + 1
        if (reactionCount >= maxReactionFrames) {
            reactionCount = 0
            return true
        } else if (reactionCount < minReactionFrames) {
            return false
        }
        
        if ( GameUtil.getRandomFloat() < getReactionOdds() ) {
            reactionCount = 0
            return true
        }

        return false
    }
    
    private func getReactionOdds() -> CGFloat {
        if (difficulty==AIDifficulty.Easy) {
            return 0.01
        } else if (difficulty==AIDifficulty.Medium) {
            return 0.1
            
        } else if (difficulty==AIDifficulty.Hard) {
            return 0.5
        }
        return 0.1
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
    
    override public func handlePuckTouched() {
        touchCounter = touchCounter + 1
        if touchCounter > 1 {
            locked = true
        }
        
        
    }
    
}