//
//  GameTimer.swift
//  AirHockeyProject
//
//  Created by divms on 3/29/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

//contains code for configuring the game timer
public class GameTimer : FittedLabelNode {
    public var timer : Timer
    
    //TODO: This 
    public init(seconds : Int64, font : String, size : CGSize) {
        timer=Timer()
        timer.setTimeLimit(seconds)
        super.init(s: size, str: timer.getRemainingTimeString()!)
        let action = SKAction.sequence([SKAction.runBlock({self.updateTimerText()}),SKAction.waitForDuration(0.1, withRange: 0.0)])
        self.runAction(SKAction.repeatActionForever(action))
        self.text = timer.getRemainingTimeString()!
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        self.zRotation = CGFloat((M_PI*3.0)/2.0)
        self.fontName=font
        self.fontColor=SKColor.whiteColor()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTimerText() {
        self.setTextNoResize(timer.getRemainingTimeString()!)
    }
    
   
}