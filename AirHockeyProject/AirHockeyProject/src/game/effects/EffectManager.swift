//
//  EffectManager.swift
//  AirHockeyProject
//
//  Created by divms on 4/4/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

// this class basically has some auxillary code for some effect handling
public class EffectManager {

    
    public class func getRGBAFromColor(color : SKColor) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let colorValue : CGColorRef  = color.CGColor

        let components = CGColorGetComponents(colorValue);
        let red : CGFloat = components[0]
        var alpha : CGFloat = 0
        var blue : CGFloat = 0
        var green : CGFloat = 0
        if (CGColorGetNumberOfComponents(color.CGColor)==2) {
            blue = red;
            green = red
            alpha =  components[1]

        } else {
            green = components[1]
            blue  =  components[2]
            alpha  = components[3]
        }
        return (red, green,blue,alpha)
    }
    
    private class func getTransitionNumber(startNumber : CGFloat, endNumber : CGFloat, transitionFraction : CGFloat) -> CGFloat {
        return ((endNumber - startNumber) * transitionFraction) + startNumber
    }
    
    //given two colors and a number between 1 and 0, returns a color that is between the two colors as specified by the fraction
    public class func getTransitionColor(startColor : SKColor, endColor : SKColor, transitionFraction : CGFloat) -> SKColor {
        let compStart = getRGBAFromColor(startColor)
        let compEnd = getRGBAFromColor(endColor)
        
        let red = getTransitionNumber(compStart.0, endNumber: compEnd.0, transitionFraction: transitionFraction)
        let green = getTransitionNumber(compStart.1, endNumber: compEnd.1, transitionFraction: transitionFraction)

        let blue = getTransitionNumber(compStart.2, endNumber: compEnd.2, transitionFraction: transitionFraction)

        let alpha = getTransitionNumber(compStart.3, endNumber: compEnd.3, transitionFraction: transitionFraction)
        
        return SKColor(red: red, green: green, blue: blue, alpha: alpha)

    }
    
    
    
    
    //given a point in the parent's coordinates, executes a spark effect there
    public class func runSparkEffect(point : CGPoint, parent : SKNode) {
        let emitter : SKEmitterNode = SKEmitterNode(fileNamed: "Spark.sks")
        
        emitter.position = point
        
        parent.addChild(emitter)
        let action = SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()])
        emitter.runAction(action) // ensures we quickly remove the effect
    }
    
    public class func runFlashEffect(node: SKShapeNode, originalColor : SKColor, flashColor : SKColor) {
        node.removeActionForKey("flashEffect")

        
        node.fillColor = flashColor
       
        
        
        
        let duration : CGFloat = 0.1
        let transitionOne = SKAction.customActionWithDuration(Double(duration), actionBlock: {
            (temp, elapsedTime) in
            let fraction  = elapsedTime / duration
            let curColor = self.getTransitionColor(originalColor, endColor: flashColor, transitionFraction: CGFloat(fraction))
            node.fillColor = curColor
        })
        let transitionTwo = SKAction.customActionWithDuration(Double(duration), actionBlock: {
            (temp, elapsedTime) in
            let fraction  = elapsedTime / duration
            let curColor = self.getTransitionColor(flashColor, endColor: originalColor, transitionFraction: CGFloat(fraction))
            node.fillColor = curColor
        })
        
        let action = SKAction.sequence([transitionOne,transitionTwo, SKAction.runBlock({node.fillColor = originalColor})])
        node.runAction(action, withKey: "flashEffect")
    }

}