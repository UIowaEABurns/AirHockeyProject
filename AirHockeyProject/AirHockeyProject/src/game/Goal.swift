//
//  Goal.swift
//  AirHockeyProject
//
//  Created by divms on 3/31/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

//todo: want a sprite node probably
public class Goal : SKShapeNode {
    
    private var playerNumber : Int // the player number of the DEFENDING player
    private var gravField : SKFieldNode?
    // initializes a goal with the given size and an
    //anchor point of (0,0). The top will be a barrier that will allow the puck in, and the other three sides are solid
    public init(size : CGSize, visibleHeight : CGFloat, playerNum : Int) {
        playerNumber = playerNum
        
        super.init()
        
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0,y: 0), size: size), nil)
        self.name=GOAL_NAME
        
        self.fillColor = SKColor.clearColor()
        self.zPosition = zPositionGoal
        self.attachEdges()
        
        //next, attach the goal texture
        let sprite = SKSpriteNode(imageNamed: "goalTexture.png")
        
        sprite.size = CGSize(width: self.frame.width, height: visibleHeight)
        sprite.position = CGPoint(x: 0, y: self.frame.height - sprite.frame.height)
        sprite.anchorPoint = CGPoint(x: 0,y: 0)
        sprite.lightingBitMask = lightCategory
        self.addChild(sprite)
        
        
    }
    
    private func attachEdges() {
        GameUtil.attachVerticalEdges(self, category: edgeCategory)
        GameUtil.attachHorizontalEdges(self,category: barrierCategory)
        self.childNodeWithName("bottomEdge")!.physicsBody!.categoryBitMask = edgeCategory
        (self.childNodeWithName("bottomEdge")! as! SKShapeNode).strokeColor = SKColor.greenColor()

        let goalEdge = (self.childNodeWithName("topEdge")!) as! SKShapeNode
        goalEdge.strokeColor = SKColor.clearColor()
        goalEdge.fillColor = SKColor.clearColor()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //returns either 1 or 2, the number of the defending player
    public func getPlayerNumber() -> Int {
        return playerNumber
    }
    
    //returns two CGPoints, marking the two edges of the goal line in the coordinate system of the table
    public func getGoalLine() -> (CGPoint, CGPoint) {
        let goalEdge = self.childNodeWithName("topEdge")!
        var p1 : CGPoint = CGPoint(x: goalEdge.frame.minX, y: goalEdge.frame.minY)
        var p2 : CGPoint = CGPoint(x: goalEdge.frame.maxX, y: goalEdge.frame.maxY)
        
        p1 = self.parent!.convertPoint(p1, fromNode: self)
        p2 = self.parent!.convertPoint(p2, fromNode: self)
        
        return (p1,p2)
    }
    
    //does some graphical effects with a scored goal
    public func handleGoalScored() {
        let emitter : SKEmitterNode = SKEmitterNode(fileNamed: "GoalEmitter.sks")
        let points = self.getGoalLine()
        let finalPoint = CGPoint(x: (points.0.x+points.1.x)/2, y: (points.0.y+points.1.y)/2)
        emitter.position = self.convertPoint(finalPoint, fromNode: self.parent!)
        
        self.addChild(emitter)
        let action = SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()])
        emitter.runAction(action)

    }
    
    public func addGravity() {
        if (gravField != nil) {
            removeGravity()
        }
        gravField = SKFieldNode.radialGravityField()
        gravField!.strength = 7
        gravField!.falloff = 0.6
        gravField!.categoryBitMask = gravCategory
        
        
        let goalEdge = self.childNodeWithName("topEdge")!
        var p1 : CGPoint = CGPoint(x: goalEdge.frame.minX, y: goalEdge.frame.minY)
        var p2 : CGPoint = CGPoint(x: goalEdge.frame.maxX, y: goalEdge.frame.maxY)
        
        gravField!.position = CGPoint(x: (p1.x + p2.x)/2 , y: (p1.y + p2.y)/2 - 100)
        
        self.addChild(gravField!)
    }
    
    public func removeGravity() {
        if (gravField != nil) {
            gravField!.removeFromParent()
        }
    }
    
}
