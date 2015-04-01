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
    //anchor point of (0,0). The goal hit box will be the bottom line, and the sides will be edges. The top will be a barrier
    public init(size : CGSize, playerNum : Int) {
        playerNumber = playerNum
        super.init()
        
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0,y: 0), size: size), nil)
        self.name="goal"
        
        self.fillColor = SKColor.blackColor()
        self.zPosition = zPositionGoal
        self.attachEdges()
        
    }
    
    private func attachEdges() {
        GameUtil.attachVerticalEdges(self, category: edgeCategory)
        GameUtil.attachHorizontalEdges(self,category: barrierCategory)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //returns either 1 or 2, the number of the defending player
    public func getPlayerNumber() -> Int {
        return playerNumber
    }
    
}
