//
//  MagnetPowerup.swift
//  AirHockeyProject
//
//  Created by divms on 4/17/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation


public class MagnetPowerup  : PowerupDelegate {
    
    
    override public func getTexture() -> String {
        return "MagnetPowerup.png"
    }
    
    override public func startEffect(p: Player) {
        super.startEffect(p)
        p.getPaddle()!.addGravity()
    }
    
    override public func endEffect() {
        self.owningPlayer!.getPaddle()!.removeGravity()

    }
}