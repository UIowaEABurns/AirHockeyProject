//
//  Paddle.swift
//  AirHockeyProject
//
//  Created by divms on 3/27/15.
//  Copyright (c) 2015 divms. All rights reserved.
//


//TODO: We actually want textured nodes, but I'm just testing physics with simple graphics
import Foundation
import SpriteKit
public class Paddle : SKShapeNode {
    private var radius : Double?
    private var density : Double?
    
    
    
    func getRadius() -> Double? {
        return radius
    }
    func getDensity() -> Double? {
        return density
    }
    func setRadius(d : Double?) {
        radius=d
    }
    func setDensity(d : Double?) {
        density=d
    }

}