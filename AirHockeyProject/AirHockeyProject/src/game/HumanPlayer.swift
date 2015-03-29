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
    
    
    
    override func getMovementVector() -> CGVector? {
        let inputManager = self.getScene().getInputManager()
        // move the puck to the mouse
        var vector : CGVector? = nil
        let input : CGPoint? = inputManager.getInputForPlayer(self.getPlayerNumber())
        
        if (!(input==nil)) {
            return self.getPaddleVectorToPoint(input!)
            
            
        }
        
        return nil
    }
    
    
    
}