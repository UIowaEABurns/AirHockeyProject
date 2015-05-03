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
    
    
    var isOnePlayer : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height/2 - 3))
        playerTwoHalf = TwoPBaseView(frame: rect, playerNumber: 2, eventDelegate: self)
        
        if (!isOnePlayer) {
            playerTwoHalf!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        } else {
            playerTwoHalf!.setToAIScreen()
            Users.logout(false) // log player 2 out so that player one can be that person if they choose
        }
        self.view.addSubview(playerTwoHalf!)

        // Do any additional setup after loading the view, typically from a nib.
        let rect2 = CGRect(origin: CGPoint(x: 0,y: (self.view.bounds.height/2 + 3)), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height/2 - 2))
        
        playerOneHalf = TwoPBaseView(frame: rect2, playerNumber: 1, eventDelegate: self)
        self.view.addSubview(playerOneHalf!)
        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate

        self.view.bringSubviewToFront(muteWidget)
        
        
        let blackLineView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.bounds.height/2 - 3), size: CGSize(width: self.view.frame.width, height: 6)))
        blackLineView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(blackLineView)
        
        Util.applyBackgroundToView(self.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = true
        AirHockeyConstants.unloadThemeChooser()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readySelected() {
        let onePlayer : Bool = isOnePlayer
        
        if (playerOneHalf!.readyButtonView.isReady() && (playerTwoHalf!.readyButtonView.isReady() || onePlayer)) {
            
            playerOneHalf!.readyButtonView.setReady(false)
            playerTwoHalf!.readyButtonView.setReady(false)
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
                
                game.settingsProfile.setAIDifficulty(playerTwoHalf!.aiDifficultySelector.currentIndex + 1)
            } else if ident == "SettingsSegue" {
                //TODO: This will need to change to avoid going to the theme chooser
                let settingsVC = segue.destinationViewController as! SettingsViewController
                settingsVC.settingsProfile = playerOneHalf!.settingsProfile
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        playerOneHalf!.handleLayoutChange()
        playerTwoHalf!.handleLayoutChange()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func handleLoginChange() {
        playerOneHalf!.loadPickerData()
        playerTwoHalf!.loadPickerData()
    }
    
}

