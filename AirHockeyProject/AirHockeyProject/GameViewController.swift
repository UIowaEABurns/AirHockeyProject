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
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
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

    public var playerOne : User? = nil
    public var playerTwo : User? = nil
    public var settingsProfile : SettingsProfile!
    
    
    override public func viewDidLoad() {
        self.navigationController!.navigationBar.hidden = true
        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate
        super.viewDidLoad()
        let soundManager : SoundManager = SoundManager()
        if (isDemo) {
            soundManager.isMuted = true
        }
        //TODO : Pass in the correct values here
        scene = GameScene(size: self.view.frame.size,p1: playerOne,p2: playerTwo,profile: settingsProfile, sound: soundManager, nav: self.navigationController)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        //skView.frameInterval = 2
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
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
