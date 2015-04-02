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

    //TODO: Will be necessary to represent other objects on the board
    private var physicsObjects  : [SKNode] = []
    private var goalWidthRatio : CGFloat
    //goal width is a number between
    init(rect : CGRect, goalWidthRatio : CGFloat) {
        self.goalWidthRatio = goalWidthRatio
        super.init()
        self.path = CGPathCreateWithRect(rect, nil)

        self.fillColor = SKColor.grayColor()
        self.strokeColor = SKColor.clearColor()
        //self.physicsBody=SKPhysicsBody(edgeLoopFromRect: rect)
        //self.physicsBody?.categoryBitMask = edgeCategory
        //creates a center line that paddles cannot cross
        
        attachEdgesAndGoals()
        let centerHeight : CGFloat = 1
        let size : CGSize = CGSize(width: self.frame.width, height: centerHeight)
        
        
        
        
        let centerRect = CGRect(origin: CGPoint(x: 0,y: 0), size: size)
        
        var midline = SKShapeNode(rect: centerRect)
        
        midline.fillColor=SKColor.whiteColor()
        
        midline.physicsBody=SKPhysicsBody(edgeLoopFromRect: centerRect)
        midline.physicsBody!.categoryBitMask = barrierCategory
        midline.physicsBody!.collisionBitMask = paddleCategory // the midline only blocks paddles
        midline.physicsBody!.restitution=TABLE_BARRIER_RESTITUTION
        midline.position = CGPoint(x: 0, y: self.frame.height/2)
        
        self.addChild(midline)
        
    }
    
   
    private func attachEdgesAndGoals() {
        var nodes : [SKNode] = []
        
        let goalWidth = goalWidthRatio * self.frame.width
        let wallWidth = (self.frame.width - goalWidth) / 2
       
        GameUtil.attachVerticalEdges(self, category: edgeCategory)
        
        //this part creates the 4 walls flankings the goals
        
        var originPoints = [CGPoint(x: 0, y: 0), CGPoint(x: goalWidth+wallWidth, y: 0), CGPoint(x: 0, y: self.frame.height), CGPoint(x: goalWidth+wallWidth, y: self.frame.height)]
        for originPoint in originPoints {
            var edge=SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: wallWidth, height: 0.5)))
            edge.position = originPoint
            nodes.append(edge)
            
        }
        //TODO: height?
        let goalSize = CGSize(width: goalWidth, height: 200)
        let bottomGoal = Goal(size: goalSize, playerNum : 1)
        bottomGoal.position = CGPoint(x: wallWidth, y: -bottomGoal.frame.height)
        self.addChild(bottomGoal)
        
        let topGoal = Goal(size: goalSize, playerNum : 2)
        topGoal.zRotation = CGFloat(M_PI)

        topGoal.position = CGPoint(x: wallWidth+topGoal.frame.width, y: self.frame.maxY+topGoal.frame.height)
        self.addChild(topGoal)
       
        
        for node in nodes {

            self.addChild(node)
            
            node.physicsBody=SKPhysicsBody(edgeFromPoint: CGPoint(x: 0,y: 0), toPoint: CGPoint(x: node.frame.width, y: node.frame.height))
            node.physicsBody!.categoryBitMask = edgeCategory

            
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
    
    // resets the puck by giving it to the given player. Player one is on the bottom, player two is on the top
    //TODO: this needs to be a bit more involved to work correctly. Specifically, there needs to be some time delay,
    // some effects, and so on.  This is basically just some test code
    public func resetPuckToPlayer(playerNumber : Int) {
        if (playerNumber==1) {
            puck.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.height / 4)
        } else {
            puck.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.height / 4)
        }
        puck.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
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
    
    //returns the goal that the given player is defending
    public func getDefendingGoal(playerNumber: Int)-> Goal! {
        for node in children {
            let sknode = node as SKNode
            if sknode.name==GOAL_NAME {
                let goal = sknode as Goal
                if goal.getPlayerNumber()==playerNumber {
                    return goal
                }
            }
        }
        return nil
    }
}