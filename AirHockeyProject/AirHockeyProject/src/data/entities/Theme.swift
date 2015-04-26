//
//  Theme.swift
//  AirHockeyProject
//
//  Created by divms on 4/4/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit
public class Theme {
    var fontName : String?
    var boardName : String
    var dark : Bool = false
    var customEmitters : [CustomEmitter] = []
    init(name : String) {
        boardName = name
    }
    
    init(name : String, font : String) {
        fontName = font
        boardName = name
    }
    
    func getTableImageFile() -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(boardName + "Table.png")
    }
    
    func getBackgroundImageFile() -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(boardName + "Background.png")
    }
    
    func getTableImageThumbFile() -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(boardName + "TableThumb.png")
    }
    
    func getBackgroundImageThumbFile() -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(boardName + "BackgroundThumb.png")
    }
    
    
    func getBackgroundMusicName() -> String {
        return boardName + "BackgroundMusic"
    }
    
    //TODO: Change these if we get new sounds
    
    func getPuckWallSoundName() -> String {
        return "classicPuckHitWall"
    }
    func getPuckPaddleSoundName() -> String {
        return "classicPuckHitPaddle"
    }
    func getGoalSound() -> String {
        return "classicGoalSound"
    }
    
    func getFontColor() -> SKColor {
        if dark {
            return SKColor.blackColor()
        }
        return SKColor.whiteColor()
    }
 
}