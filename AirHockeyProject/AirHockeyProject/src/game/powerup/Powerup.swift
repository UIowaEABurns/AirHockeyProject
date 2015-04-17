//
//  Powerup.swift
//  AirHockeyProject
//
//  Created by divms on 4/17/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class Powerup : SKSpriteNode {
    
    private var delegate : PowerupDelegate?
    var timer : Timer?
    public class func getRandomPowerup(size: CGSize, del : PowerupDelegate) -> Powerup {
        let powerup = Powerup(imageNamed: del.getTexture())
        
        powerup.size = size

        powerup.configurePowerup(del)
        
        
        
        return powerup
    }
    
    public func moveToRandomPositionOnBoard(parent : SKNode) {
        let y = (parent.frame.midY)  - self.frame.height/2
        let x = GameUtil.getRandomFloatInRange(parent.frame.minX, max: parent.frame.maxX  - self.frame.width)
        
        self.position = CGPoint(x: x, y: y)
    }
    
    
    public func configurePowerup(del : PowerupDelegate) {
        self.zPosition = zPositionPowerup
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.categoryBitMask = powerupCategory
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.contactTestBitMask = paddleCategory
        
        let emitter = SKEmitterNode(fileNamed: "Sparkle.sks")
        
        emitter.particlePositionRange = CGVector(dx: self.frame.width+5, dy: self.frame.height+5)
        emitter.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        
        self.addChild(emitter)
        
        delegate = del
        timer = Timer()
        timer!.setTimeLimit(20)
    }
    
    public func touched(p : Player) {
        println("touched by player " + String(p.getPlayerNumber()))
        timer!.start()
        self.removeFromParent()
        delegate!.startEffect(p)
    }
    
    //returns true if finished
    public func update() -> Bool {
        if (timer!.isDone() == nil) {
            return false
        }
        if (timer!.isDone()!) {
            
            delegate!.endEffect()
            return true
        }
        return false
    }
}