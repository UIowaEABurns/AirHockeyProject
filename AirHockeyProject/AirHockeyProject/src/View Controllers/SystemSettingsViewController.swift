//
//  SystemSettingsViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/15/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit
class SystemSettingsViewController : UIViewController {
    
    @IBOutlet weak var bgmController: UISlider!
    
    @IBOutlet weak var fxController: UISlider!
    
    override func viewWillAppear(animated: Bool) {
        println(BG_MUSIC_VOLUME)
        bgmController.setValue(BG_MUSIC_VOLUME, animated: false)
        fxController.setValue(FX_VOLUME,animated:false)
        println(bgmController.value)
    }
    
    @IBAction func soundChanged(sender: AnyObject) {
        
        FX_VOLUME = fxController.value
        BG_MUSIC_VOLUME = bgmController.value
        SoundManager.volumeChanged()
    }
    
    
    
    @IBAction func fxChanged(sender: AnyObject) {
        SoundManager().playButtonPressedSound()
    }
    @IBAction func saveSound(sender: AnyObject) {
        println(FX_VOLUME)
        AirHockeyConstants.saveVolumeSettings()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}