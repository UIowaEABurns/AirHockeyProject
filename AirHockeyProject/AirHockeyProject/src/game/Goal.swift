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
    
    
    // initializes a goal with the given size and an
    //anchor point of (0,0). The top will be a barrier that will allow the puck in, and the other three sides are solid
    public init(size : CGSize, playerNum : Int) {
        playerNumber = playerNum
        super.init()
        
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0,y: 0), size: size), nil)
        self.name=GOAL_NAME
        
        self.fillColor = SKColor.blackColor()
        self.zPosition = zPositionGoal
        self.attachEdges()
        
        
    }
    
    private func attachEdges() {
        GameUtil.attachVerticalEdges(self, category: edgeCategory)
        GameUtil.attachHorizontalEdges(self,category: barrierCategory)
        self.childNodeWithName("bottomEdge")!.physicsBody!.categoryBitMask = edgeCategory
        (self.childNodeWithName("bottomEdge")! as SKShapeNode).strokeColor = SKColor.greenColor()



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
    
}
