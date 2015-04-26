//
//  SettingsViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController  {
    
    let sizes = ["Very Small", "Small", "Normal", "Large", "Very Large"]
    private let defaultSettings = AirHockeyConstants.getDefaultSettings()
    
    
    
    
    @IBOutlet weak var puckRadiusWidget: ArrowPickerWidget!
    
    @IBOutlet weak var settingsScrollView: UIScrollView!
    
    var settingsProfile : SettingsProfile!
    private var originalTheme : String!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController!.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        let defaultPuckSize = defaultSettings.getPuckRadius()!
        
        
        
        originalTheme = settingsProfile.getThemeName()!
        puckRadiusWidget.titleLabel.text = "Puck Radius"
        puckRadiusWidget.values = sizes
        puckRadiusWidget.setItem(2)
        setWidgetsFromSettings(settingsProfile)
        
        
        
        
        
    }
   
    
    
    func setWidgetsFromSettings(setttings : SettingsProfile) {
        puckRadiusWidget.setItem(settingsProfile.getPuckRadiusValue()!)
    }
    
    func setProfileFromWidgets() {
        originalTheme = settingsProfile.getThemeName()!
        settingsProfile.setPuckRadius(GameObjectSize.intToSize(puckRadiusWidget.currentIndex)!)
    }
    
    @IBAction func saveSettings(sender: UIButton) {
        setProfileFromWidgets()
        Settings.updateSettingsProfile(settingsProfile)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ident = segue.identifier {
            if ident == "ThemeSegue" {
                let dest = segue.destinationViewController as! BoardSelectionViewController
                dest.settingsProfile = self.settingsProfile
                return
            }
        }
        //original will have been saved if we were doing that
        settingsProfile.setThemeName(originalTheme)
        
    }
}