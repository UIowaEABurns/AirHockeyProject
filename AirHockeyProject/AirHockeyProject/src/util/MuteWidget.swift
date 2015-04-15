//
//  MuteWidget.swift
//  AirHockeyProject
//
//  Created by divms on 4/14/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit
class MuteWidget : UIView {
    @IBOutlet var display: UIView!

    @IBOutlet weak var soundImageView: UIImageView!
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("MuteWidget", owner: self, options: nil)
        //self.display.frame = self.frame
        self.display.bounds = self.bounds
        self.display.frame.origin = CGPoint(x: 0, y: 0)
        self.backgroundColor = UIColor.clearColor()
        setImage()
        self.addSubview(self.display)
    }
    
    private func setImage() {
        if (muted) {
            soundImageView.image = UIImage(contentsOfFile: NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("soundOffIcon.png"))
        } else {
            soundImageView.image = UIImage(contentsOfFile: NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("soundOnIcon.png"))
        }
    }
    
    @IBAction func ToggleMute(sender: UIButton) {
        muted = !muted
        if (muted) {
            SoundManager.mute()
        } else {
            SoundManager.unmute()
            SoundManager().playButtonPressedSound()
        }
        AirHockeyConstants.saveMuteSetting()
        setImage()
    }
}