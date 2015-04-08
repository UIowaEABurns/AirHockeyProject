//
//  WinScreen.swift
//  AirHockeyProject
//
//  Created by divms on 4/8/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class WinScreen : SKNode {
    
    
    
    var winLabel : FittedLabelNode
    
    init(p1Score : Int, p2Score : Int, p1Name : String, p2Name : String, t : Theme, parent : SKNode) {
        let widthFraction : CGFloat = 0.8
        let topLabelSize = CGSize(width: parent.frame.width * widthFraction, height: parent.frame.height * 0.15)
        
        var finalMessage = "Draw!"
        if (p1Score>p2Score) {
            finalMessage = p1Name + " wins!"
        } else if (p2Score>p1Score) {
            finalMessage = p2Name + " wins!"
        }
        
        
        
        winLabel = FittedLabelNode(s: topLabelSize, str: finalMessage)
        winLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        winLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        winLabel.position = CGPoint(x: parent.frame.midX, y: parent.frame.maxY-150)
        winLabel.zPosition = zPositionOverlayButtons
        super.init()
        self.addChild(winLabel)

        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}