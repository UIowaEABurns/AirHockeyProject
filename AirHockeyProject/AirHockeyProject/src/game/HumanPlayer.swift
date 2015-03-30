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
        let inputManager = self.getScene().getInputManager()
        // move the puck to the mouse
        var vector : CGVector? = nil
        let input : CGPoint? = inputManager.getInputForPlayer(self.getPlayerNumber())
        let paddle = self.getPaddle()!
        if (!(input==nil)) {
            
            if (Geometry.distance(paddle.position, b: input!)<=snapDistance) {
                paddle.position=input!
                paddle.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                
                
                return nil
            }
            
            return self.getPaddleVectorToPoint(input!)
            
            
        }
        
        return nil
    }
    
    
    
}