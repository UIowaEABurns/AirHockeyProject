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
    
    private var maxSpeed : CGFloat // this is the maximum speed that this player's  paddle is allowed to go
    private var maxAcceleration : CGFloat // this is the
    private var scene : GameScene
    private var playerNumber : Int
    private var paddle : Paddle? // the paddle for this player
    
    private var touchMass : CGFloat = 40
    private var noTouchMass  :CGFloat = 5
    
    init (speed : CGFloat, accel : CGFloat, s : GameScene, i : Int) {
        maxSpeed=speed
        maxAcceleration = accel
        scene=s
        playerNumber = i 
    }
    
    //this is the function called by the game to allow the player to move. In other words, this is the entry point
    // for all player logic. This can not be overriden, because it enforces some constraints on movemenet
    public final func movePaddle() {
        var vector = getMovementVector()
        if (vector==nil) {
            paddle?.physicsBody!.mass=noTouchMass

            return
        }
        paddle?.physicsBody!.mass=touchMass
        let acceleration = Geometry.magnitude(vector!)
        if (acceleration>maxAcceleration) {
            vector = Geometry.getVectorOfMagnitude(vector!, b: maxAcceleration)
            
        }
        paddle!.physicsBody!.velocity.dx=paddle!.physicsBody!.velocity.dx+vector!.dx
        paddle!.physicsBody!.velocity.dy=paddle!.physicsBody!.velocity.dy+vector!.dy

        //paddle!.physicsBody?.applyImpulse(vector!)

        
    }
    
    // this is where game logic is written in subclasses. Returns a CGVector that will be applied to this player's paddle
    func getMovementVector() -> CGVector? {
        fatalError("This method must be overwritten")
    }
    
    public func getPaddle() -> Paddle? {
        return paddle
    }
    
    public func setPaddle(p : Paddle) {
        paddle=p
    }
    public func getScene() -> GameScene {
        return scene
    }
    public func getPlayerNumber() -> Int {
        return playerNumber
    }
    public func getMaxSpeed() -> CGFloat {
        return maxSpeed
    }
   
    
    
    // given a point to move the paddle to, gets the vector that works best for moving the paddle to the point
    public func getPaddleVectorToPoint(point : CGPoint) -> CGVector {
        var vector = Geometry.normalVector(self.getPaddle()!.position, b: point)
        let speed : CGFloat = maxAcceleration
        vector.dx = vector.dx * speed
        vector.dy = vector.dy * speed
        
        let distance = Geometry.distance(point,b: paddle!.position)
        
            
        return vector
        
    }
    
}