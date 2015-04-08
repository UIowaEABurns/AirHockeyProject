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
public class Puck: SKSpriteNode {
    
    public func configurePuck(density : CGFloat, settingsProfile : SettingsProfile) {
        self.physicsBody=SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody?.restitution=0.95
        self.physicsBody?.allowsRotation=true
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
    
    
    public func doIntangibleAnimation() {
        let blink = EffectManager.blink(self)
        let physicsBody = self.physicsBody
        var finalAction = SKAction.sequence([SKAction.runBlock({self.physicsBody = nil}),blink,blink,blink,blink,SKAction.runBlock({self.physicsBody = physicsBody})])
        self.runAction(finalAction)
    }
    
    
    public func capSpeed(speed : CGFloat) {
        if !(self.physicsBody==nil) {
            if (Geometry.magnitude(self.physicsBody!.velocity) > speed) {
                self.physicsBody!.velocity = Geometry.getVectorOfMagnitude(self.physicsBody!.velocity, b: speed)
            }
        }
        
    }
    
}

