//
//  Button.swift
//  AirHockeyProject
//
//  Created by divms on 4/1/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

enum State : String {
    case FingerDown = "FingerDown"
    case Normal = "Normal"
    
    
}
let BUTTON_ACTIVE_COLOR = SKColor.redColor()
let BUTTON_INACTIVE_COLOR  = SKColor.whiteColor()

public class Button : SKShapeNode, TouchHandlerDelegate {
    private var block : dispatch_block_t
    private var active : Bool
    var label : FittedLabelNode
    private var size : CGSize
    
    private var activeTouch : AnyObject? = nil
    
    // 0 = nothing happening
    // 1 = finger is pressed down on
    
    private var state : State = State.Normal
    override init() {
        block = {}
        active = true
        size = CGSize(width: 0,height: 0)
        label = FittedLabelNode(s: size, str: "")
        super.init()
        

    }
    
    
    public func setText(s : String) {
        label.setText(s)
        
    }
    
    init(fontNamed fontName: String!, block : dispatch_block_t, s : CGSize) {
        self.block = {}
        active = true
        size = s
        label = FittedLabelNode(s: size, str: "")
        label.setFontName(fontName)
        super.init()
        self.block = block
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0, y: 0), size: size), nil)
        
        //self.strokeColor = SKColor.whiteColor()
        label.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        self.addChild(label)
        handleTextColor()
    }
    
    public func setFontSize(s : CGFloat) {
        label.setFontSize(s)
    }
    public func getFontSize() -> CGFloat {
        return label.fontSize
    }
    
    private func execute() {
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
            if (containsNow || containsBefore) {
                self.registerTouch(touch, containsNow: containsNow, containsBefore: containsBefore)
            }
            
        }
        handleTextColor()
    }
    
    private func handleTextColor() {
        if (self.state == State.Normal) {
            self.label.fontColor = BUTTON_INACTIVE_COLOR
        } else {
            self.label.fontColor = BUTTON_ACTIVE_COLOR

        }
    }
    
    private func registerTouch(touch : AnyObject, containsNow : Bool, containsBefore : Bool) {
       
        if (touch.phase == UITouchPhase.Began) {
            registerTouchStarted(touch)
        }
        if (touch.phase == UITouchPhase.Ended && containsNow) {
            registerTouchEnded()
        }
        if (touch.phase == UITouchPhase.Moved && !containsNow) {
            registerTouchLeaves()
        }
        
        if (touch.phase == UITouchPhase.Moved && containsNow && !containsBefore) {
            registerTouchEnters(touch)
        }
        
    }
    
    //called when a touch begins on this button
    private func registerTouchStarted(touch : AnyObject) {
        state = State.FingerDown
        self.activeTouch = touch
    }
    
    //called when a touch ends (as in, the user removes their finger) when it is over the button
    private func registerTouchEnded() {
        if (state == State.FingerDown) {
            execute()
            state = State.Normal
            self.activeTouch = nil
        }
    }
    
    private func registerTouchEnters(touch: AnyObject) {
        
        if (touch===activeTouch) {
            state = State.FingerDown
        }
    }
    
    //called when a touch leaves the (as in, the user drags their finger off of the button)
    private func registerTouchLeaves() {
        state = State.Normal
        
    }
    
    public func activate() {
        active = true
    }
    public func inactivate() {
        active = false
        state = State.Normal
    }
    public func isActive() -> Bool {
        return active
    }
}