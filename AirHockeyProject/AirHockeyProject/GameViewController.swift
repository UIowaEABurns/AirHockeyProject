//
//  GameViewController.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

public class GameViewController: UIViewController {
    private var scene : GameScene!
    public var isDemo = false

    
    override public func viewDidLoad() {
        println("one")
        super.viewDidLoad()
        println("two")
        let soundManager : SoundManager = SoundManager()
        if (isDemo) {
            soundManager.isMuted = true
        }
        println("three")
        //TODO : Pass in the correct values here
        scene = GameScene(size: self.view.frame.size,p1: nil,p2: nil,profile: AirHockeyConstants.getDefaultSettings(), sound: soundManager)
        // Configure the view.
        println("four")
        let skView = self.view as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        println("five")
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        println("six")
        skView.presentScene(scene)

        
    }

    override public func shouldAutorotate() -> Bool {
        return false
    }

    override public func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
}
