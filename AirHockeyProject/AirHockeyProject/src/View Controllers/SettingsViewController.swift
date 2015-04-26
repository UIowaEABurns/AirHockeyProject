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
    let frictions = ["None", "Low", "Medium", "High", "Very High"]
    let powerupBools = ["On", "Off"]
    
    
    //TODO: Make options more robust?
    let goals = ["∞","1","2","3","4","5","6","7","8","9","10"]
    let times = ["∞","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00"]
    private let defaultSettings = AirHockeyConstants.getDefaultSettings()
    
    
    
    
    @IBOutlet weak var puckRadiusWidget: ArrowPickerWidget!
    @IBOutlet weak var p1PaddleRadiusWidget: ArrowPickerWidget!
    
    @IBOutlet weak var p2PaddleRadiusWidget: ArrowPickerWidget!
    @IBOutlet weak var frictionWidget: ArrowPickerWidget!
    
    
    @IBOutlet weak var powerupsEnabledWidget: ArrowPickerWidget!
    @IBOutlet weak var goalsWidget: ArrowPickerWidget!
    
    @IBOutlet weak var timeWidget: ArrowPickerWidget!
    @IBOutlet weak var settingsScrollView: UIScrollView!
    
    @IBOutlet weak var chooseThemeButton: UIButton!
    var settingsProfile : SettingsProfile!
    private var originalTheme : String!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController!.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        let defaultPuckSize = defaultSettings.getPuckRadius()!
        println(chooseThemeButton.frame.origin)
        
        
        originalTheme = settingsProfile.getThemeName()!
        puckRadiusWidget.titleLabel.text = "Puck Radius"
        puckRadiusWidget.values = sizes
        p1PaddleRadiusWidget.titleLabel.text = "P1 Paddle Radius"
        p1PaddleRadiusWidget.values = sizes
        p2PaddleRadiusWidget.titleLabel.text = "P2 Paddle Raidus"
        p2PaddleRadiusWidget.values = sizes
        frictionWidget.titleLabel.text = "Friction"
        frictionWidget.values = frictions
        powerupsEnabledWidget.titleLabel.text = "Powerups"
        powerupsEnabledWidget.values = powerupBools
        goalsWidget.titleLabel.text = "Goals To Win"
        goalsWidget.values = goals
        timeWidget.titleLabel.text = "Time Limit"
        timeWidget.values = times
        setWidgetsFromSettings(settingsProfile)

        
        
        settingsScrollView.contentSize = CGSize(width: settingsScrollView.frame.width, height: chooseThemeButton.frame.origin.y + chooseThemeButton.frame.height)
        
        
    }
   
    
    
    func setWidgetsFromSettings(setttings : SettingsProfile) {
        puckRadiusWidget.setItem(settingsProfile.getPuckRadiusValue()!)
        p1PaddleRadiusWidget.setItem(settingsProfile.getPlayerOnePaddleRadiusValue()!)
        p2PaddleRadiusWidget.setItem(settingsProfile.getPlayerTwoPaddleRadiusValue()!)
        frictionWidget.setItem(settingsProfile.getFrictionValue()!)
        if (settingsProfile.arePowerupsEnabled()!) {
            powerupsEnabledWidget.setItem(0)
        } else {
            powerupsEnabledWidget.setItem(1)
        }
        goalsWidget.setItem(settingsProfile.getGoalLimit()!)
        timeWidget.setItem(settingsProfile.getTimeLimit()!/60)

    }
    
    func setProfileFromWidgets() {
        originalTheme = settingsProfile.getThemeName()!
        settingsProfile.setPuckRadius(GameObjectSize.intToSize(puckRadiusWidget.currentIndex)!)
        settingsProfile.setPlayerOnePaddleRadius(GameObjectSize.intToSize(p1PaddleRadiusWidget.currentIndex)!)
        settingsProfile.setPlayerTwoPaddleRadius(GameObjectSize.intToSize(p2PaddleRadiusWidget.currentIndex)!)
        settingsProfile.setFriction(GameObjectSize.intToSize(frictionWidget.currentIndex)!)
        if powerupsEnabledWidget.currentIndex==0 {
            settingsProfile.setPowerupsEnabled(true)
        } else {
            settingsProfile.setPowerupsEnabled(false)
        }
        settingsProfile.setGoalLimit(goalsWidget.currentIndex)
        settingsProfile.setTimeLimit(timeWidget.currentIndex * 60)
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