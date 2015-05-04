//
//  Player.swift
//  AirHockeyProject
//
//  Created by divms on 3/29/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation

import SpriteKit
// represents one of the players of the air hockey game. This class is "abstract" -- we only use human or AI player classes
public class Player {
    
    
    private var playerNumber : Int
    private var paddle : Paddle? // the paddle for this player
    
    private var inputManager : InputManager
    private var playingTable : Table
    public var scene : GameScene
    public var score : Int

    
    private var paddlePositionBeforeUpdate : CGPoint

    
    init (i : Int, input : InputManager, p : GameScene) {
       
        playerNumber = i
        score = 0
        playingTable = p.getPlayingTable()
        scene = p
        inputManager = input
        paddlePositionBeforeUpdate = CGPoint(x: 0,y: 0)
    }
    
    //this is the function called by the game to allow the player to move. In other words, this is the entry point
    // for all player logic. This can not be overriden, because it enforces some constraints on movemenet
    public final func movePaddle() {
        paddlePositionBeforeUpdate = paddle!.position
        var vector = getMovementVector()
        
        if (vector==nil) {

            return
        }
        paddle!.physicsBody!.angularVelocity = 0.0
        
        let acceleration = Geometry.magnitude(vector!)
        if (acceleration>self.getMaxAcceleration()) {
            vector = Geometry.getVectorOfMagnitude(vector!, b: self.getMaxAcceleration())
            
        }
        
        paddle!.physicsBody!.velocity.dx=paddle!.physicsBody!.velocity.dx+vector!.dx
        paddle!.physicsBody!.velocity.dy=paddle!.physicsBody!.velocity.dy+vector!.dy

        
        
    }
    
    // this is where game logic is written in subclasses. Returns a CGVector that will be applied to this player's paddle
    func getMovementVector() -> CGVector? {
        fatalError("This method must be overwritten")
    }
    
    //called after didSimulatePhysics
    //enforces that the paddle always remain on the correct half of the table
    func processPaddlePosition() {
        if (!playingTable.getHalfForPlayer(playerNumber).contains(paddle!.position)) {
            paddle!.position = paddle!.lastPosition!
        }
    }
    
    public func getPaddle() -> Paddle? {
        return paddle
    }
    
    public func setPaddle(p : Paddle) {
        paddle=p
    }
   
    public func getPlayerNumber() -> Int {
        return playerNumber
    }
    public func getMaxSpeed() -> CGFloat {
        fatalError("This method must be overwritten")

    }
    
    public func getMaxAcceleration() -> CGFloat {
        fatalError("This method must be overwritten")

    }
   
    //returns the spped we want to be going if we want to get to a point the given distance away
    //TODO: The "5" is sort of magic -- really should be refactored
    private func getDesiredSpeed(distance : CGFloat, speedMult : CGFloat)-> CGFloat {
        if (distance==0) {
            return 0
        }
        var multiplier = distance * speedMult
       
        
        return CGFloat(log(distance)*multiplier)
    }
    // given a point to move the paddle to, gets the vector that works best for moving the paddle to the point
    public func getPaddleVectorToPoint(point : CGPoint) -> CGVector {
        return getPaddleVectorToPoint(point,speedMult: 5)
        
        
    }
    
    // given a point to move the paddle to, gets the vector that works best for moving the paddle to the point
    public func getPaddleVectorToPoint(point : CGPoint, speedMult : CGFloat) -> CGVector {
        let distance = Geometry.distance(point,b: paddle!.position)
        if (distance<=0.002) {
            return CGVector(dx: 0, dy: 0)
        }
        //first, we get the desired vector
        var desiredVector = Geometry.normalVector(self.getPaddle()!.position, b: point)
        
        desiredVector.dx = desiredVector.dx * self.getDesiredSpeed(distance, speedMult: speedMult)
        desiredVector.dy = desiredVector.dy * self.getDesiredSpeed(distance, speedMult: speedMult)
        
        //next, this is our current vector
        let currentVector=self.paddle!.physicsBody!.velocity
        
        
        
        
        let finalVector = Geometry.getTransitionVector(currentVector, to: desiredVector)
        
        return finalVector
        
        
    }
    // returns a vector that will try to move the paddle across the given point as fast as possible
    // unlike getPaddleVectorToPoint, this one won't stop on the given point
    public func getPaddleVectorThroughPoint(point : CGPoint) -> CGVector {
        var desiredVector = Geometry.normalVector(self.getPaddle()!.position, b: point)
        desiredVector.dx = desiredVector.dx * self.getMaxAcceleration()
        desiredVector.dy = desiredVector.dy * self.getMaxAcceleration()
        //next, this is our current vector
        let currentVector=self.paddle!.physicsBody!.velocity
        
        
        
        
        let finalVector = Geometry.getTransitionVector(currentVector, to: desiredVector)
        
        return finalVector
    }
    
    public func getInputManager()-> InputManager {
        return inputManager
    }
    public func getPlayingTable() -> Table {
        return playingTable
    }
    
    public func getPaddlePositionBeforeUpdate() -> CGPoint {
        return paddlePositionBeforeUpdate
    }
    
    public func handlePuckTouched() {
        
    }
    
}