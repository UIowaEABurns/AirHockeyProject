//
//  ReadyButtonView.swift
//  AirHockeyProject
//
//  Created by divms on 4/23/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class ReadyButtonView : UIView {
    @IBOutlet var buttonView: UIView!
    
    @IBOutlet weak var readyButton: UIButton!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("ReadyButtonView", owner: self, options: nil)
        self.buttonView.bounds = self.bounds
        self.buttonView.frame.origin = CGPoint(x: 0, y: 0)
        self.backgroundColor = UIColor.clearColor()
        
        readyButton.layer.cornerRadius = readyButton.frame.width / 2
        
        self.addSubview(self.buttonView)
    }
    
}