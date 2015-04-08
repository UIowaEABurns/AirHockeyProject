//
//  Themes.swift
//  AirHockeyProject
//
//  Created by divms on 4/5/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit
var themes : [Theme] = []

//manages all the game's themes
public class Themes : NSObject, NSXMLParserDelegate {
    
    private var currentTheme : Theme?
    //loads all themes from the given file
    public func loadThemes() {
        var path : NSString = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("themeconfig.xml")
        let parser = NSXMLParser(stream: NSInputStream(fileAtPath: path)!)
        parser.delegate = self
        currentTheme = nil
        parser.parse()
        themes.append(currentTheme!)
        currentTheme = nil
        
        
    }
    
    
    //returns all the current thems
    public func getAllThemes() -> [Theme] {
        return themes
    }
    
    func parser(parser: NSXMLParser!,didStartElement elementName: String!, namespaceURI: String!, qualifiedName : String!, attributes attributeDict: NSDictionary!) {
        
        if (elementName == "theme"){
            if (!(currentTheme==nil)) {
                themes.append(currentTheme!)
                currentTheme = nil
            }
            
            currentTheme = Theme(name: attributeDict["name"] as String)
        } else if (elementName == "fontName") {
            currentTheme!.fontName = attributeDict["value"] as? String
        } else if (elementName == "emitter") {
            let emitterName = attributeDict["name"] as? String
            let x = attributeDict["x"] as? String
            let y = attributeDict["y"] as? String
            println(x)
            if (x==nil || y==nil) {
                currentTheme?.customEmitters.append(CustomEmitter(emitterName: emitterName!))

            } else {
                currentTheme?.customEmitters.append(CustomEmitter(emitterName: emitterName!,x: CGFloat(x!.toInt()!),y: CGFloat(y!.toInt()!)))

            }
        }
    }
    
    public func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
    }
    
    public func parser(parser: NSXMLParser!, foundCharacters string: String!) {
    }
    public  func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        println(parseError)
    }
    
    public class func getThemeByName(name : String) -> Theme? {
        for theme in themes {
            if theme.boardName == name {
                return theme
            }
        }
        return nil
    }
}