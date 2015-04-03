//
//  AIPlayer.swift
//  AirHockeyProject
//
//  Created by divms on 4/1/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit
public class AIPlayer : Player  {
    private let WANDER_MIN_SPEED : CGFloat = 10.0
    private let WANDER_MAX_SPEED : CGFloat = 20.0
    
    
    private var defendPoint : CGPoint!
    private var puck : Puck!
    private var defendingHalf : CGRect!
    override init(speed: CGFloat, accel: CGFloat, i: Int, input: InputManager, p: Table) {
        super.init(speed: speed, accel: accel, i: i, input: input, p: p)
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
        return Geometry.getVectorOfMagnitude(CGVector(dx: xMag, dy: yMag), b: speed)
    }
    //returns a vector that tries to move the paddle back in front of the goal that it is defending
    private func getDefendVector() -> CGVector {
        
        
        return self.getPaddleVectorToPoint(defendPoint)
    }
    
    private func getStrikeVector() -> CGVector {
        return self.getPaddleVectorThroughPoint(puck.position)
    }
    
    
    //this is the entry point to the AI logic
    override func getMovementVector() -> CGVector? {
        let wanderVector = getWanderVector(WANDER_MIN_SPEED,maxSpeed: WANDER_MAX_SPEED)
        let puckOnThisHalf = defendingHalf.contains(puck.position)
        if (puckOnThisHalf) {
            return getStrikeVector()
        } else {
            return getDefendVector()
        }
        
        
    }
    
    override func processPaddlePosition() {
        
    }
    
}