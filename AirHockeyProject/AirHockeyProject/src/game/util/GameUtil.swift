//
//  GameUtil.swift
//  AirHockeyProject
//
//  Created by divms on 3/31/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit
public class GameUtil {
    
    //attaches solid nodes to the edges of the given SKNode. The physics nodes will have the given category. 
    // names the edges "leftVertEdge" and "rightVertEdge"
    class func attachVerticalEdges(n : SKNode, category : UInt32) {
        
        
        var originPoints = [CGPoint(x: n.frame.maxX,y: n.frame.minY), CGPoint(x: n.frame.minX,y: n.frame.minY)]
        var names = ["rightVertEdge", "leftVertEdge" ]
        for i in 0..<originPoints.count{
            let originPoint = originPoints[i]
            let name = names[i]
            
            var vertEdge = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 0.5, height: n.frame.height)))
            vertEdge.position=originPoint
            n.addChild(vertEdge)

            vertEdge.name = name
            vertEdge.physicsBody=SKPhysicsBody(edgeFromPoint: CGPoint(x: 0,y: 0), toPoint: CGPoint(x: vertEdge.frame.width, y: vertEdge.frame.height))
            
            vertEdge.physicsBody!.categoryBitMask = category
            
            
        }
    }
    
    //attaches solid nodes to the edges of the given SKNode. The physics nodes will have the given category.
    // names the edges "bottomEdge" and "topEdge"
    class func attachHorizontalEdges(n : SKNode, category : UInt32) {
        
        
        var originPoints = [CGPoint(x: n.frame.minX,y: n.frame.minY), CGPoint(x: n.frame.minX,y: n.frame.maxY)]
        var names = ["bottomEdge", "topEdge" ]
        for i in 0..<originPoints.count{
            let originPoint = originPoints[i]
            let name = names[i]
            
            var edge = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: n.frame.width, height: 0.5)))
            edge.position=originPoint
            n.addChild(edge)
            
            edge.name = name
            edge.physicsBody=SKPhysicsBody(edgeFromPoint: CGPoint(x: 0,y: 0), toPoint: CGPoint(x: edge.frame.width, y: edge.frame.height))
            
            edge.physicsBody!.categoryBitMask = category
            
            
        }
    }
    //returns a random CGFloat between 0 and 1
    class func getRandomFloat() -> CGFloat  {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    //gets a random float in the range of the two given floats
    class func getRandomFloatInRange(min: CGFloat, max: CGFloat) -> CGFloat {
        return (getRandomFloat() * (max-min) + min)
    }
    
    
}