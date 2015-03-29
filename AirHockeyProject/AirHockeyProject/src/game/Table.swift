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
        
        let centerHeight : CGFloat = 10
        let point=CGPoint(x: 0, y: self.frame.midY-(centerHeight/2))
        let size : CGSize = CGSize(width: self.frame.width, height: centerHeight)
        println("midline width")
        println(size.width)
        let centerRect = CGRect(origin: point, size: size)
        
        var midline = SKShapeNode(rect: centerRect)
        
        midline.fillColor=SKColor.brownColor()
        
        midline.physicsBody=SKPhysicsBody(edgeLoopFromRect: centerRect)
        midline.physicsBody!.categoryBitMask = barrierCategory
        midline.physicsBody!.collisionBitMask = paddleCategory // the midline only blocks paddles
        self.addChild(midline)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // returns a CGRect representing the bounds of the bottom half of the table,
    // which is the half belonging to player one
    func getPlayerTwoHalf()-> CGRect {
        var rect = self.frame
        var originPoint=rect.origin
        originPoint.y = rect.midY //middle starts at the middle of the board, with the same x value
        return CGRect(origin: originPoint, size: CGSize(width: rect.width, height: rect.height/2))

    }
    
    //returns a CGRect representing the bounds of the top half of the table, which is the player two half
    func getPlayerOneHalf() -> CGRect {
        return CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: self.frame.height/2))
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