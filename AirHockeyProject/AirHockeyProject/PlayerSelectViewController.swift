//
//  PlayerSelectViewController.swift
//  AirHockeyProject
//
//  Created by uics13 on 4/13/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class PlayerSelectViewController: UIViewController, PlayerSelectEventDelegate {
    private var playerOneHalf : TwoPBaseView?
    private var playerTwoHalf : TwoPBaseView?
    @IBOutlet weak var muteWidget: MuteWidget!
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height/2 - 2))
        playerTwoHalf = TwoPBaseView(frame: rect, playerNumber: 2, eventDelegate: self)
        
        
        playerTwoHalf!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.view.addSubview(playerTwoHalf!)

        // Do any additional setup after loading the view, typically from a nib.
        let rect2 = CGRect(origin: CGPoint(x: 0,y: (self.view.bounds.height/2 + 2)), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height/2 - 2))
        
        playerOneHalf = TwoPBaseView(frame: rect2, playerNumber: 1, eventDelegate: self)
        self.view.addSubview(playerOneHalf!)
        self.navigationController!.navigationBar.hidden = true
        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate

        self.view.bringSubviewToFront(muteWidget)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readySelected() {
        if (playerOneHalf!.readySwitch.on && playerTwoHalf!.readySwitch.on) {
            playerOneHalf!.readySwitch.setOn(false, animated: false)
            playerTwoHalf!.readySwitch.setOn(false,animated: false)
            self.performSegueWithIdentifier("TwoPShowGameSegue", sender: self)
        }
    }
    
    func backSelected() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func settingsSelected(settings: SettingsProfile) {
        self.performSegueWithIdentifier("SettingsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ident = segue.identifier {
            if ident == "TwoPShowGameSegue" {
                
                let game = segue.destinationViewController as! GameViewController
                game.playerOne = playerOneHalf!.user
                game.playerTwo = playerTwoHalf!.user
                game.settingsProfile = playerOneHalf!.settingsProfile
            } else if ident == "SettingsSegue" {
                //TODO: This will need to change to avoid going to the theme chooser
                let themeChooser = segue.destinationViewController as! BoardSelectionViewController
                themeChooser.settingsProfile = playerOneHalf!.settingsProfile
            }
        }
        
    }
    
}

