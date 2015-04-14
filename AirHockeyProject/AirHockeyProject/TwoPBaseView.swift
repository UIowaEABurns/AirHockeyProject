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
    
    @IBOutlet var Display: UIView!
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        self.addSubview(self.Display)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        
        self.Display.bounds = frame
        self.Display.frame = frame
        self.backgroundColor = UIColor.redColor()
        //on button press, remove then add new
        self.addSubview(self.Display)
    }
    
    
}
