//
//  Table.swift
//  AirHockeyProject
//
//  Created by divms on 3/28/15.
//  Copyright (c) 2015 divms. All rights reserved.
//
//TODO: We actually want textured nodes, but I'm just testing physics with simple graphics

import Foundation
import SpriteKit
public class Table : SKShapeNode {
    
    private var puck : Puck!

    private var otherObjects  : [SKNode]! = []
    
    private var goalWidthRatio : CGFloat = 0.25 // how wide is the goal compared to width of board TODO: allow configuration
    
    init(rect : CGRect) {
        super.init()
        
        self.path = CGPathCreateWithRect(rect, nil)

        self.fillColor = SKColor.grayColor()
        self.strokeColor = SKColor.clearColor()
        //self.physicsBody=SKPhysicsBody(edgeLoopFromRect: rect)
        //self.physicsBody?.categoryBitMask = edgeCategory
        //creates a center line that paddles cannot cross
        attachEdges()
        let centerHeight : CGFloat = 1
        let size : CGSize = CGSize(width: self.frame.width, height: centerHeight)
        
        
        
        
        let centerRect = CGRect(origin: CGPoint(x: 0,y: 0), size: size)
        
        var midline = SKShapeNode(rect: centerRect)
        
        midline.fillColor=SKColor.whiteColor()
        
        midline.physicsBody=SKPhysicsBody(edgeLoopFromRect: centerRect)
        midline.physicsBody!.categoryBitMask = barrierCategory
        midline.physicsBody!.collisionBitMask = paddleCategory // the midline only blocks paddles
        midline.physicsBody!.restitution=0.01
        midline.position = CGPoint(x: 0, y: self.frame.height/2)
        
        self.addChild(midline)
        
    }
    
    
    private func attachEdges() {
        var nodes : [SKNode] = []
        
        let goalWidth = goalWidthRatio * self.frame.width
        let wallWidth = (self.frame.width - goalWidth) / 2
        
        //first, attach solid edges to the side
        var vertEdge = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 0.5, height: self.frame.height)))
        nodes.append(vertEdge)
        vertEdge.physicsBody=SKPhysicsBody(edgeFromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: 0, y: self.frame.height))
        
        
        
        
        vertEdge = SKShapeNode(rect: CGRect(origin: CGPoint(x: self.frame.width,y: 0), size: CGSize(width: 0.5, height: self.frame.height)))
        nodes.append(vertEdge)
        vertEdge.physicsBody=SKPhysicsBody(edgeFromPoint: CGPoint(x: self.frame.width, y: 0), toPoint: CGPoint(x: self.frame.width, y: self.frame.height))

        var originPoint = CGPoint(x: 0, y: 0)
        var leftBottomEdge=SKShapeNode(rect: CGRect(origin: originPoint, size: CGSize(width: wallWidth, height: 0.5)))
        nodes.append(leftBottomEdge)
        leftBottomEdge.physicsBody=SKPhysicsBody(edgeFromPoint: originPoint, toPoint: CGPoint(x: originPoint.x+wallWidth, y: originPoint.y))
        
        
        originPoint.x = goalWidth+wallWidth
        var rightBottomEdge = SKShapeNode(rect: CGRect(origin: originPoint, size: CGSize(width: wallWidth, height: 0.5)))
        nodes.append(rightBottomEdge)
        rightBottomEdge.physicsBody = SKPhysicsBody(edgeFromPoint: originPoint, toPoint: CGPoint(x: originPoint.x+wallWidth, y: originPoint.y))
        
        
        
        originPoint.x = 0
        originPoint.y = self.frame.height
        var leftTopEdge=SKShapeNode(rect: CGRect(origin: originPoint, size: CGSize(width: wallWidth, height: 0.5)))
        nodes.append(leftTopEdge)
        leftTopEdge.physicsBody=SKPhysicsBody(edgeFromPoint: originPoint, toPoint: CGPoint(x: originPoint.x+wallWidth, y: originPoint.y))
        
        originPoint.x = goalWidth+wallWidth
        var rightTopEdge = SKShapeNode(rect: CGRect(origin: originPoint, size: CGSize(width: wallWidth, height: 0.5)))
        nodes.append(rightTopEdge)
        rightTopEdge.physicsBody = SKPhysicsBody(edgeFromPoint: originPoint, toPoint: CGPoint(x: originPoint.x+wallWidth, y: originPoint.y))
    
        
        originPoint.x = wallWidth
        originPoint.y = 0
        var bottomGoalBarrier=SKShapeNode(rect: CGRect(origin: originPoint, size: CGSize(width: wallWidth, height: 0.5)))
        bottomGoalBarrier.physicsBody=SKPhysicsBody(edgeFromPoint: originPoint, toPoint: CGPoint(x: originPoint.x+wallWidth, y: originPoint.y))
        bottomGoalBarrier.physicsBody!.categoryBitMask = barrierCategory
        bottomGoalBarrier.strokeColor = SKColor.clearColor()
        self.addChild(bottomGoalBarrier)
        
        originPoint.y = self.frame.height
        var topGoalBarrier=SKShapeNode(rect: CGRect(origin: originPoint, size: CGSize(width: wallWidth, height: 0.5)))
        topGoalBarrier.physicsBody=SKPhysicsBody(edgeFromPoint: originPoint, toPoint: CGPoint(x: originPoint.x+wallWidth, y: originPoint.y))
        topGoalBarrier.physicsBody!.categoryBitMask = barrierCategory
        topGoalBarrier.strokeColor = SKColor.clearColor()
        self.addChild(topGoalBarrier)
        
        for node in nodes {
            node.physicsBody!.categoryBitMask = edgeCategory

            self.addChild(node)
            println(node.frame.origin)

        }
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // returns a CGRect representing the bounds of the bottom half of the table,
    // which is the half belonging to player one. Coordinates are with relation to the table itself
    func getPlayerTwoHalf()-> CGRect {
        var rect = self.frame
        var originPoint=CGPoint(x: 0,y: 0)
        originPoint.y = rect.height/2 //middle starts at the middle of the board, with the same x value
        
        return CGRect(origin: originPoint, size: CGSize(width: rect.width, height: rect.height/2))

    }
    
    //returns a CGRect representing the bounds of the top half of the table, which is the player two half.
    //coordinates are with relation to the table itself.
    func getPlayerOneHalf() -> CGRect {
        var originPoint=CGPoint(x: 0,y: 0)
        return CGRect(origin: originPoint, size: CGSize(width: self.frame.width, height: self.frame.height/2))
    }
   
    
    //adds the puck to this table, including positioning the puck and adding it to the scene
    public func setPuck(p : Puck) {
        puck = p
        puck.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
       
        self.addChild(puck)
    }
    public func getPuck() -> Puck {
        return puck
    }
}