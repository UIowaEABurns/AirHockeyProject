//
//  CustomEmitter.swift
//  AirHockeyProject
//
//  Created by divms on 4/7/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit


//these are emitters that have built in coordinates so that they can be placed from a config file
public class CustomEmitter {
    var emitterName : String
    private var x : CGFloat?
    private var y : CGFloat?
    var align : String?
    init(emitterName : String, x : CGFloat, y : CGFloat) {
        self.emitterName = emitterName
        self.x=x
        self.y=y
    }
    //this initializes the node without an x and y, so they will be assumed to be central
    init(emitterName : String) {
        self.emitterName = emitterName
    }

    
    public func getX(parent : SKNode) -> CGFloat {
        if !(x==nil) {
            return x!
        }
        return parent.frame.midX
    }
    
    public func getY(parent : SKNode) -> CGFloat {
        if !(y==nil) {
            return y!
        } else if (align == "top") {
            return parent.frame.maxY + 5

        }
        return parent.frame.midY
    }
   
}