//
//  Geometry.swift
//  AirHockeyProject
//
//  Created by divms on 3/27/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit
public class Geometry {
    
    // returns the euclidean distance between the two points
    class func distance(a : CGPoint, b : CGPoint) -> CGFloat {
        return sqrt(pow(a.x-b.x,2) + pow(a.y-b.y,2))
    }
    
    //returns the magnitude of the given vector
    class func magnitude(a : CGVector) -> CGFloat {
    
        return sqrt(pow(a.dx,2)+pow(a.dy,2))
    }
    
    //gets a vector in the same direction as the first vector, but with the given magnitude
    class func getVectorOfMagnitude(a : CGVector, b  : CGFloat) -> CGVector {
        let mag = magnitude(a)
        
        return CGVector(dx: (a.dx/mag)*b,dy: ((a.dy/mag)*b))
    }
    
    // returns a normalized vector from the first point to the second point (as in, a vector in the direction of the second
    // point with a magnitude of 1
    class func normalVector(a : CGPoint, b: CGPoint) -> CGVector {
        let dist = distance(a,b: b)
        
        let x = (b.x-a.x)/dist
        let y = (b.y-a.y)/dist
        
        return CGVector(dx: x,dy: y)
    }
    
    class func getTransitionVector(from : CGVector, to: CGVector) -> CGVector {
        return CGVector(dx: to.dx-from.dx, dy: to.dy-from.dy)
    }
}