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
        bgmController.setValue(BG_MUSIC_VOLUME, animated: false)
        fxController.setValue(FX_VOLUME,animated:false)
        self.navigationController!.navigationBar.hidden = false
        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate

        self.navigationController!.navigationBar.topItem!.title = "Cancel"
        Util.applyBackgroundToView(self.view)
    }
    
    @IBAction func soundChanged(sender: AnyObject) {
        
        FX_VOLUME = fxController.value
        BG_MUSIC_VOLUME = bgmController.value
        SoundManager.volumeChanged()
    }
    
    override func viewWillDisappear(animated: Bool) {
        AirHockeyConstants.loadVolumeSettings()
        SoundManager.volumeChanged()
    }
    
    @IBAction func fxChanged(sender: AnyObject) {
        SoundManager().playButtonPressedSound()
    }
    @IBAction func saveSound(sender: AnyObject) {
        
        AirHockeyConstants.saveVolumeSettings()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}