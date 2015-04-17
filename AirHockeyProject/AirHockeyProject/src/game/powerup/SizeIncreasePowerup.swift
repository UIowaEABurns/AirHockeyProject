//
//  SizeIncreasePowerup.swift
//  AirHockeyProject
//
//  Created by divms on 4/17/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class SizeIncreasePowerup : PowerupDelegate {
    
    override public func getTexture() -> String {
        return "classicPuck.png"
    }
    
    override public func startEffect(p: Player) {
        super.startEffect(p)
        p.getPaddle()!.xScale = 1.5
        p.getPaddle()!.yScale = 1.5
    }
    
    override public func endEffect() {
        self.owningPlayer!.getPaddle()!.xScale = 1.0
        self.owningPlayer!.getPaddle()!.yScale = 1.0
    }
    
}