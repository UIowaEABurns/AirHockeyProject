//
//  Button.swift
//  AirHockeyProject
//
//  Created by divms on 4/1/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class Button : SKShapeNode, TouchHandlerDelegate {
    private var block : dispatch_block_t
    private var active : Bool
     var label : SKLabelNode!
    // 0 = nothing happening
    // 1 = finger is pressed down on
    
    private var state : Int = 0
    override init() {
        block = {}
        active = true
        super.init()
        

    }
    
    
    public func setText(s : String) {
        label.text = s
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0, y: 0), size: label.frame.size), nil)
        label.position = CGPoint(x: self.frame.midX,y: self.frame.midY)


    }
    
    init(fontNamed fontName: String!, block : dispatch_block_t) {
        self.block = {}
        active = true
        super.init()
        self.block = block
        label = SKLabelNode(fontNamed: fontName)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0,height: 0)), nil)
        
        self.strokeColor = SKColor.whiteColor()
        
        //label.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        
        self.addChild(label)
    }
    
    private func execute() {
        println("executing code block")
        block()
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func handleTouches(touches: NSSet) {
        if (!active) {
            return
        }
        for touch: AnyObject in touches {
            let gameLocation = touch.locationInNode(self.parent)
            
            let prevGameLocation  = touch.previousLocationInNode(self.parent)
            
            let containsNow = self.containsPoint(gameLocation)
            let containsBefore = self.containsPoint(prevGameLocation)
            if (containsNow) {
                self.registerTouch(touch, containsNow: true)
            } else if (containsBefore) {
                self.registerTouch(touch, containsNow: false)
            }
            
        }
    }

    private func registerTouch(touch : AnyObject, containsNow : Bool) {
        
        
       
        if (touch.phase == UITouchPhase.Began) {
            registerTouchStarted()
        }
        if (touch.phase == UITouchPhase.Ended && containsNow) {
            registerTouchEnded()
        }
        if (touch.phase == UITouchPhase.Moved && !containsNow) {
            registerTouchLeaves()
        }
        
    }
    
    //called when a touch begins on this button
    private func registerTouchStarted() {
        state = 1
    }
    
    //called when a touch ends (as in, the user removes their finger) when it is over the button
    private func registerTouchEnded() {
        if (state == 1) {
            execute()
            state = 0
        }
    }
    
    //called when a touch leaves the (as in, the user drags their finger off of the button)
    private func registerTouchLeaves() {
        state = 0
    }
    
    public func activate() {
        active = true
    }
    public func inactivate() {
        active = false
        state = 0
    }
    public func isActive() -> Bool {
        return active
    }
}