//
//  VortexPoweruip.swift
//  AirHockeyProject
//
//  Created by divms on 4/19/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation

public class VortextPowerup : PowerupDelegate {
    override public func getTexture() -> String {
        return "VortexPowerup.png"
    }
    
    override public func startEffect(p: Player) {
        super.startEffect(p)
        self.scene.getPlayingTable().getOpposingGoal(p.getPlayerNumber()).addGravity()
    }
    
    override public func endEffect() {
        let p = self.owningPlayer!
        self.scene.getPlayingTable().getOpposingGoal(p.getPlayerNumber()).removeGravity()

    }
}