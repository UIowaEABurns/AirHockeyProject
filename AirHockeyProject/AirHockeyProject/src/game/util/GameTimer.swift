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
    private var singleSecond : Bool
    private var block : dispatch_block_t?
    public init(seconds : Int64, font : String, size : CGSize, singleSecond : Bool) {
        timer=Timer()
        
        timer.setTimeLimit(seconds)
        self.singleSecond = singleSecond
        super.init(s: size, str: "")
        self.setFittedText(getTimerText() as String)
        let action = SKAction.sequence([SKAction.runBlock({self.updateTimerText()}),SKAction.waitForDuration(0.1, withRange: 0.0)])
        self.runAction(SKAction.repeatActionForever(action))
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right

        self.fontName=font
        
    }
    
    public func setBlock(changeHandler : dispatch_block_t) {
        block = changeHandler
    }
    
    public func setFinished(){
        if (!singleSecond) {
            self.setTextNoResize("0:00")

        } else {
            self.setTextNoResize("0")

        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTimerText() -> NSString {
        let string : NSString = timer.getRemainingTimeString()!
        if (!singleSecond) {
            return string
        } else {
           return string.substringFromIndex(string.length-1)
        }
    }
    
    private func updateTimerText() {
        let oldText = self.text
        self.setTextNoResize(getTimerText() as String)
        if (self.text != oldText) {
            if (block != nil) {
                if (timer.isDone() != nil && !timer.isDone()!) {
                    block!()

                }
            }
        }
    }
   
    
   
}