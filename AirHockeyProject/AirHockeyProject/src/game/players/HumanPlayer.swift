//
//  HumanPlayer.swift
//  AirHockeyProject
//
//  Created by divms on 3/29/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class HumanPlayer : Player {
    
    private var snapDistance : CGFloat = 12 // the distance from which the paddle will just snap to an input and stop
    
    override func getMovementVector() -> CGVector? {
        

        let inputManager = self.getInputManager()
        // move the puck to the mouse
        var vector : CGVector? = nil
        let input : CGPoint? = inputManager.getInputForPlayer(self.getPlayerNumber())
        let paddle = self.getPaddle()!
        if (!(input==nil)) {
            
            //paddles have no momentum unless they are simply released
            self.getPaddle()?.physicsBody!.velocity.dx = 0
            self.getPaddle()?.physicsBody!.velocity.dy = 0
            
            return self.getPaddleVectorToPoint(input!)
            
            
        }
        
        return nil
    }
    
    override func processPaddlePosition() {
        
    }
    
    
    
}