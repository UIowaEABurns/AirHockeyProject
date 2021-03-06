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
public class Paddle : SKSpriteNode {
    private var light : SKLightNode?
    private var gravField : SKFieldNode?
    private var playerNumber : Int?
    var lastPosition : CGPoint?
   
    
    public func getPlayerNumber()-> Int? {
        return playerNumber
    }
    
    public func configurePaddle(playerNumber: Int, radius: CGFloat, settingsProfile : SettingsProfile, mass : CGFloat) {
        self.playerNumber = playerNumber
        self.physicsBody=SKPhysicsBody(circleOfRadius: radius)

        if (playerNumber==1) {
            self.color = settingsProfile.getPlayerOnePaddleColor()!
        } else if (playerNumber==2) {
            self.color = settingsProfile.getPlayerTwoPaddleColor()!
        }
        self.colorBlendFactor = 0.7
        self.physicsBody?.restitution=0
        self.physicsBody?.mass=mass
        self.physicsBody?.allowsRotation=true
        self.physicsBody?.friction=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody?.linearDamping=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody?.angularDamping=CGFloat(settingsProfile.getFriction()!)
        self.physicsBody?.categoryBitMask = paddleCategory
        self.zPosition = zPositionPaddle
        self.physicsBody!.collisionBitMask = self.physicsBody!.collisionBitMask ^ powerupCategory
        self.physicsBody!.fieldBitMask = 0

        self.size = CGSize(width: radius * 2, height: radius * 2)
    }
    
    func addLight() {
        light = SKLightNode()
        
        light!.lightColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        light!.enabled  = true
        
        light!.categoryBitMask = lightCategory
        self.addChild(light!)
    }
    func removeLight() {
        if light != nil {
            light!.removeFromParent()
        }
    }
    
    func addGravity() {
        gravField = SKFieldNode.radialGravityField()
        gravField!.strength = 3
        gravField!.falloff = 0.7
        gravField!.categoryBitMask = gravCategory
        self.addChild(gravField!)
    }
    func removeGravity() {
        if gravField != nil {
            gravField!.removeFromParent()
        }
    }
}