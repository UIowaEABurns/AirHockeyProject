//
//  Puck.swift
//  AirHockeyProject
//
//  Created by divms on 3/27/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

//TODO: We actually want textured nodes, but I'm just testing physics with simple graphics

import Foundation
import SpriteKit
public class Puck: SKShapeNode {
    
    public func configurePuck(density : CGFloat, settingsProfile : SettingsProfile) {
        self.physicsBody=SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody?.restitution=0.95
        self.physicsBody?.allowsRotation=true
        self.fillColor=SKColor.blackColor()
        self.physicsBody!.density=CGFloat(density)
        self.physicsBody!.usesPreciseCollisionDetection=true
        self.physicsBody!.friction=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody!.linearDamping=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody!.angularDamping=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody!.categoryBitMask = puckCategory
        self.physicsBody!.collisionBitMask = self.physicsBody!.collisionBitMask ^ barrierCategory
        self.zPosition = zPositionPuck
        self.physicsBody!.contactTestBitMask = paddleCategory | edgeCategory
        self.name = PUCK_NAME
    }
   
    
}

