//
//  2PBaseView.swift
//  AirHockeyProject
//
//  Created by uics13 on 4/13/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit
class TwoPBaseView: UIView {
    
    //multiple of these displays
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet var LoginDisplay: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet var Display: UIView!
    @IBOutlet var ReadyDisplay: UIView!
    @IBOutlet weak var GuestButton: UIButton!
    
    @IBOutlet weak var baseScreenPlayerText: UILabel!
    
    private var currentScreen : UIView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        //self.addSubview(self.Display)
    }
    
    init(frame: CGRect, playerNumber : Int) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        NSBundle.mainBundle().loadNibNamed("LoginView", owner:self, options: nil)
        NSBundle.mainBundle().loadNibNamed("ReadyView", owner:self, options: nil)
        self.Display.frame.size = frame.size
        self.Display.bounds = self.bounds

        self.LoginDisplay.frame = Display.frame
        self.LoginDisplay.bounds = Display.bounds

        self.ReadyDisplay.frame = Display.frame
        self.ReadyDisplay.bounds = Display.bounds

        
        self.LoginDisplay.hidden = true
        self.ReadyDisplay.hidden = true
        
        
        
        self.backgroundColor = UIColor.redColor()
        //on button press, remove then add new
        self.addSubview(self.Display)
        self.addSubview(ReadyDisplay)
        self.addSubview(LoginDisplay)
        
        
        
        baseScreenPlayerText.text = "Player " + String(playerNumber)
        
        if (playerNumber == 2) {
            self.BackButton.hidden = true
        } else {
            println("here is bounds info")
            println(self.Display.frame.origin)
            println(self.Display.frame.size)
            println(self.Display.bounds.size)
            println(self.Display.bounds.origin)
        }
    }
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        
        switchScreens(LoginDisplay)
    }
    @IBAction func GuestButtonPressed(sender: AnyObject) {
        
        switchScreens(ReadyDisplay)
    }
    @IBAction func CancelLoginButton(sender: AnyObject) {
        switchScreens(Display)
    }
    
    @IBAction func BackReadyViewButton(sender: AnyObject) {
        switchScreens(Display)
    }
    
    
    private func switchScreens(newScreen : UIView) {
        newScreen.hidden = false
        if currentScreen != nil {
            currentScreen!.hidden = true
        }
        currentScreen = newScreen
    }
    
    @IBAction func BaseViewBackButtonPressed(sender: AnyObject) {
    
    
    }
    
    
    
}
