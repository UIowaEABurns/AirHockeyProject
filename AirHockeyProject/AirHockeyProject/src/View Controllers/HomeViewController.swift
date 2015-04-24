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
    private var gameView : SKView?
    @IBOutlet weak var logoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
    }
    
    private func setupGame() {
        let widthFraction : CGFloat = 1
        let heightFraction : CGFloat = 1
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.frame.width * heightFraction, height: self.view.frame.height * widthFraction))
        gameView = SKView(frame: rect)
        println(gameView!.frame.origin)
        gameView!.backgroundColor = UIColor.clearColor()
        gameView!.alpha = 0.6
        gameView!.userInteractionEnabled = false
        let soundManager : SoundManager = SoundManager()
        soundManager.isMuted = true
        let settings = AirHockeyConstants.getDefaultSettings()
        settings.setTimeLimit(0)
        settings.setGoalLimit(0)
        settings.setPowerupsEnabled(false)
        settings.setAIDifficulty(AIDifficulty.toNumber(AIDifficulty.Hard))
        let scene = GameScene(size: gameView!.frame.size,p1: nil,p2: nil,profile: settings, sound: soundManager, nav: nil)
        scene.alpha = 1
        
        
        
        gameView!.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        gameView!.presentScene(scene)
        
        self.view.addSubview(gameView!)
        
        
        self.view.sendSubviewToBack(gameView!)
        
        
        logoImage.alpha = 0.7
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (gameView != nil) {
            gameView!.scene!.paused = true
            gameView!.presentScene(nil)
            gameView!.removeFromSuperview()
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ident = segue.identifier {
            if ident == "HomeOnePlayerSegue" {
                let dest = segue.destinationViewController as! PlayerSelectViewController
                dest.isOnePlayer = true
            } else if ident == "HomeTwoPlayerSegue" {
                let dest = segue.destinationViewController as! PlayerSelectViewController
                dest.isOnePlayer = false
            }
        }
    }
    
    override func  viewWillAppear(animated: Bool) {
        setupGame()
        self.navigationController!.navigationBar.hidden = true
    }
    
    @IBAction func buttonTouched(sender: AnyObject) {
        SoundManager().playButtonPressedSound()
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