//
//  PowerupDelegate.swift
//  AirHockeyProject
//
//  Created by divms on 4/17/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class PowerupDelegate {
    
    var owningPlayer : Player?
    var scene : GameScene
    
    init(s : GameScene) {
        scene = s
    }
    
    //the player that touched the powerup
    public func startEffect(p : Player) {
        owningPlayer = p
        
        
    }
    
    public func endEffect() {
        
    }
    
    public func getTexture() -> String {
        return ""
    }
    
}