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
    
    
    init(rect : CGRect) {
        super.init()
        
        self.path = CGPathCreateWithRect(rect, nil)

        self.fillColor = SKColor.grayColor()
        self.physicsBody=SKPhysicsBody(edgeLoopFromRect: rect)
        self.physicsBody?.categoryBitMask = edgeCategory
        //creates a center line that paddles cannot cross
        
        let centerHeight : CGFloat = 1
        let size : CGSize = CGSize(width: self.frame.width, height: centerHeight)
        
        let centerRect = CGRect(origin: CGPoint(x: 0,y: 0), size: size)
        
        var midline = SKShapeNode(rect: centerRect)
        
        midline.fillColor=SKColor.whiteColor()
        
        midline.physicsBody=SKPhysicsBody(edgeLoopFromRect: centerRect)
        midline.physicsBody!.categoryBitMask = barrierCategory
        midline.physicsBody!.collisionBitMask = paddleCategory // the midline only blocks paddles
        
        midline.position = CGPoint(x: 0, y: self.frame.height/2)
        
        self.addChild(midline)
        
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