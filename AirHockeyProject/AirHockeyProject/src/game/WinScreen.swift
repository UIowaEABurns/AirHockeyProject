//
//  WinScreen.swift
//  AirHockeyProject
//
//  Created by divms on 4/8/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit

public class WinScreen : SKNode, TouchHandlerDelegate {
    
    private var active = true
    var parentScene : GameScene
    var winLabel : FittedLabelNode
    var p1ScoreLabel : SKLabelNode
    var p2ScoreLabel : SKLabelNode
    var rematchButton : Button!
    var exitButton : Button!
    init(p1Score : Int, p2Score : Int, p1Name : String, p2Name : String, t : Theme, parent : GameScene) {
        let widthFraction : CGFloat = 0.8
        let topLabelSize = CGSize(width: parent.frame.width * widthFraction, height: parent.frame.height * 0.15)
        
        var finalMessage = "Draw!"
        if (p1Score>p2Score) {
            finalMessage = p1Name + " wins!"
        } else if (p2Score>p1Score) {
            finalMessage = p2Name + " wins!"
        }
        
        
        
        winLabel = FittedLabelNode(s: topLabelSize, str: finalMessage)
        winLabel.setFittedFontName(t.fontName!)
        winLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        winLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        winLabel.position = CGPoint(x: parent.frame.midX, y: parent.frame.maxY-150)
        winLabel.zPosition = zPositionOverlayButtons
        
        p1ScoreLabel = SKLabelNode(fontNamed: t.fontName!)
        p1ScoreLabel.fontSize = winLabel.fontSize
        p1ScoreLabel.text = String(p1Score)
        let scoreLabelDistanceFromCenter : CGFloat = 120
        let scoreLabelDistanceFromBanner : CGFloat = 80
        p1ScoreLabel.position = CGPoint(x: parent.frame.midX-scoreLabelDistanceFromCenter, y: winLabel.position.y - winLabel.frame.height-scoreLabelDistanceFromBanner)
        p1ScoreLabel.zPosition = zPositionOverlayButtons
        p2ScoreLabel = SKLabelNode(fontNamed: t.fontName!)
        p2ScoreLabel.fontSize = winLabel.fontSize
        p2ScoreLabel.text = String(p2Score)
        
        p2ScoreLabel.position = CGPoint(x: parent.frame.midX+scoreLabelDistanceFromCenter, y: winLabel.position.y - winLabel.frame.height-scoreLabelDistanceFromBanner)
        p2ScoreLabel.zPosition = zPositionOverlayButtons
        
        
        let buttonSize = CGSize(width: parent.frame.width * 0.3, height: parent.frame.height * 0.09)
        
        
        self.parentScene = parent
        super.init()
        self.addChild(winLabel)
        self.addChild(p1ScoreLabel)
        self.addChild(p2ScoreLabel)
        let overlayNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: parent.frame.width, height: parent.frame.height)))
        
        overlayNode.position = CGPoint(x: parent.frame.minX, y: parent.frame.minY)
        overlayNode.zPosition = zPositionOverlay
        overlayNode.fillColor = OVERLAY_COLOR
        self.addChild(overlayNode)
        
        rematchButton = Button(fontNamed: t.fontName!, block: {self.handleRematch()}, s: buttonSize)
        rematchButton.setText("Rematch")
        rematchButton.position = CGPoint(x: parent.frame.midX-rematchButton.frame.width/2, y: parent.frame.midY + 20)
        rematchButton.zPosition = zPositionOverlayButtons
        
        exitButton = Button(fontNamed: t.fontName!, block: {self.handleExit()}, s: buttonSize)
        exitButton.setText("Exit")
        exitButton.setFontSize(rematchButton.getFontSize())
        exitButton.position = CGPoint(x: parent.frame.midX-exitButton.frame.width/2, y: parent.frame.midY-exitButton.frame.height-20)
        exitButton.zPosition = zPositionOverlayButtons

        self.addChild(rematchButton)
        self.addChild(exitButton)

        
    }
    
    public func handleRematch() {
        self.scene!.view!.presentScene(GameScene(size: self.scene!.size, p1: parentScene.userOne, p2: parentScene.userTwo, profile: parentScene.settingsProfile,sound: parentScene.soundManager, nav: parentScene.navigationController), transition: SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.5))
        
    }
    public func handleExit() {
        parentScene.navigationController!.popViewControllerAnimated(true)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func activate() {
        active = true
    }
    public func inactivate() {
        active = false
    }
    public func isActive() -> Bool {
        return active
    }
    
    public func handleTouches(touches: NSSet) {
        exitButton.handleTouches(touches)
        rematchButton.handleTouches(touches)
    }
    
}