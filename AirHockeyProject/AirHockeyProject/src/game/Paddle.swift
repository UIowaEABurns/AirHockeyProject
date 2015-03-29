//
//  Paddle.swift
//  AirHockeyProject
//
//  Created by divms on 3/27/15.
//  Copyright (c) 2015 divms. All rights reserved.
//


//TODO: We actually want textured nodes, but I'm just testing physics with simple graphics
import Foundation
import SpriteKit
public class Paddle : SKShapeNode {
    
    private var playerNumber : Int?
    
    public func setPlayerNumber(i : Int) {
        playerNumber=i
    }
    
    public func getPlayerNumber()-> Int? {
        return playerNumber
    }
    
    public func configurePaddle(radius : CGFloat, settingsProfile : SettingsProfile) {
        self.physicsBody=SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.restitution=0.95
        self.physicsBody?.allowsRotation=true
        self.fillColor=SKColor.blueColor()
        self.physicsBody?.usesPreciseCollisionDetection=true
        self.physicsBody?.friction=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody?.linearDamping=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody?.angularDamping=CGFloat(settingsProfile.getFriction()!)
        
    }
}