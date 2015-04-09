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
    
 
}