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
    
    
    //gets a completely random vector with a magnitude in the range of the given
    private func getWanderVector(minSpeed : CGFloat, maxSpeed : CGFloat) -> CGVector {
        let xMag = 1-(GameUtil.getRandomFloat() * 2)
        let yMag = 1-(GameUtil.getRandomFloat() * 2)
        let speed = GameUtil.getRandomFloatInRange(minSpeed,max: maxSpeed)
        return Geometry.getVectorOfMagnitude(CGVector(dx: xMag, dy: yMag), b: speed)
    }
    //returns a vector that tries to move the paddle back in front of the goal that it is defending
    //TODO: Finish
    private func getDefendVector() -> CGVector {
        let table = self.getPlayingTable()
        let defendingGoal = table.getDefendingGoal(self.getPlayerNumber())
        let line : (CGPoint,CGPoint) = defendingGoal.getGoalLine()
        let perpendicularSlope = Geometry.getPerpendicularSlope(line.0, p2: line.1)
        let centerPoint = CGPoint(x: (line.0.x+line.1.x)/2, y: (line.0.y+line.1.y)/2)
        let testPointOne = Geometry.getPointAtDistanceWithSlope(centerPoint, slope: perpendicularSlope, distance: 5)
        let testPointTwo = Geometry.getPointAtDistanceWithSlope(centerPoint, slope: perpendicularSlope, distance: -5)
        var distance : CGFloat = 50
        if (table.nodeAtPoint(testPointOne)===defendingGoal) {
            distance  = -distance
        } else if (table.nodeAtPoint(testPointTwo)===defendingGoal) {
            
        }
        
        
        var defendPoint = Geometry.getPointAtDistanceWithSlope(centerPoint, slope: perpendicularSlope, distance: distance)
        
        return self.getPaddleVectorToPoint(defendPoint)
    }
    
    override func getMovementVector() -> CGVector? {
        return getDefendVector()
    }
    
}