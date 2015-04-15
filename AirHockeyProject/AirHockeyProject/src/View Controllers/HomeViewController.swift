//
//  HomeViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/14/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
class HomeViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let gameView = SKView(frame: CGRect(origin: CGPoint(x: 50,y: 0), size: CGSize(width: 300, height: 700)))
        
        
        let soundManager : SoundManager = SoundManager()
        soundManager.isMuted = true
        
        let scene = GameScene(size: gameView.frame.size,p1: nil,p2: nil,t: Themes.getDefaultTheme(), sound: soundManager)
       
        
        println(gameView.frame.size)
        
        
        gameView.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        gameView.presentScene(scene)
        gameView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 3 / 2)
        
        self.view.addSubview(gameView)
        println(gameView.frame.origin)
        gameView.frame.origin = CGPoint(x: 0, y: 0)
    }
    
   
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
       
}