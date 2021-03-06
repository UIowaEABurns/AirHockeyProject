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
    //assumes the outer node assumes outerNode has an anchor point of (0,0). point is in the coordinate system of outerNode
    private func pointInNode(outerNode : SKNode, point :CGPoint) -> Bool {
        return point.x>=outerNode.frame.minX && point.y>=outerNode.frame.minY && point.x <= outerNode.frame.maxX && point.y<=outerNode.frame.maxX
    }
    
    
    class func nodeContainsNode(outerNode : SKNode, innerNode : SKNode) -> Bool {
        return outerNode.containsPoint(CGPoint(x: innerNode.frame.minX, y: innerNode.frame.minY)) &&
            outerNode.containsPoint(CGPoint(x: innerNode.frame.minX, y: innerNode.frame.maxY)) &&
            outerNode.containsPoint(CGPoint(x: innerNode.frame.maxX, y: innerNode.frame.minY)) &&
            outerNode.containsPoint(CGPoint(x: innerNode.frame.maxX, y: innerNode.frame.maxY))
 
    }
    
    //returns the slope of the two points as if they were a line segment. If they slope is infinite, just returns 10000000 as an estimate
    class func getSlope(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        if (p2.x==p1.x) {
            return 10000000
        }
        return (p2.y - p1.y) / (p2.x - p1.x)
    }
    
    //returns the slope of the line perpendicular to the given line. If there is no such slope, just returns 10000000 as an estimate
    class func getPerpendicularSlope(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let slope = getSlope(p1,p2: p2)
        if (slope==0) {
            return 10000000
        }
        return -(1.0/slope)
    }
    
    class func getPointAtDistanceWithSlope(origin : CGPoint, slope : CGFloat, distance : CGFloat) -> CGPoint {
        let b = origin.y - slope * origin.x
        let temp : CGFloat = CGFloat(distance/CGFloat(sqrt(1 + (slope * slope))))
        let x = origin.x + temp
        let y = slope * x + b
        return CGPoint(x: x, y: y)
    }
    
    //returns a vector that is the average of all the given vectors, done by just summing up the dx and dy and dividing by the total number of vectors
    class func getAverageVector(vectors : [CGVector]) -> CGVector {
        var averageVector = CGVector(dx: 0, dy: 0)
        for vector in vectors {
            
            averageVector.dx=averageVector.dx+vector.dx
            averageVector.dy=averageVector.dy+vector.dy
        }
        
        averageVector.dx  = averageVector.dx / CGFloat(vectors.count)
        averageVector.dy  = averageVector.dy / CGFloat(vectors.count)
        return averageVector
    }
    
    private class func clamp(x : CGFloat, mini : CGFloat, maxi : CGFloat) -> CGFloat {
        let y : CGFloat = min(x, maxi)
        return max(mini,y)
    }
    
    class func getNearestPointInRect(rect : CGRect, point : CGPoint) -> CGPoint {
        let x = clamp(point.x, mini: rect.origin.x, maxi: rect.origin.x+rect.width)
        let y = clamp(point.y,mini: rect.origin.y,maxi: rect.origin.y + rect.height)
        return CGPoint(x: x, y: y)
    }
    
   
    
    
}