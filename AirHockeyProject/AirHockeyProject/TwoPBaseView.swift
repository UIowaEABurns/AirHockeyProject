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
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        self.addSubview(self.Display)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        NSBundle.mainBundle().loadNibNamed("LoginView", owner:self, options: nil)
        self.Display.bounds = frame
        self.Display.frame = frame
        self.backgroundColor = UIColor.redColor()
        //on button press, remove then add new
        self.addSubview(self.Display)
    }
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        self.LoginDisplay.bounds = frame
        self.LoginDisplay.frame = frame
        //self.removeFromSuperview()
        self.addSubview(self.LoginDisplay)
    }
    @IBAction func GuestButtonPressed(sender: AnyObject) {
        self.ReadyDisplay.bounds = frame
        self.ReadyDisplay.frame = frame
        self.addSubview(self.ReadyDisplay)
    }
    @IBAction func CancelLoginButton(sender: AnyObject) {
        self.Display.bounds = frame
        self.Display.frame = frame
        self.addSubview(self.Display)
    }
    
    
    
}
