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
    
    let colors = ["Red","Blue","Green","Yellow","Purple","Orange","Black","White"]
    
    private let defaultSettings = AirHockeyConstants.getDefaultSettings()
    
    
    @IBOutlet weak var p1PaddleColorWidget: ArrowPickerWidget!
    
    @IBOutlet weak var p2PaddleColorWidget: ArrowPickerWidget!
    
    @IBOutlet weak var puckRadiusWidget: ArrowPickerWidget!
    @IBOutlet weak var p1PaddleRadiusWidget: ArrowPickerWidget!
    
    @IBOutlet weak var p2PaddleRadiusWidget: ArrowPickerWidget!
    @IBOutlet weak var frictionWidget: ArrowPickerWidget!
    
    
    @IBOutlet weak var powerupsEnabledWidget: ArrowPickerWidget!
    @IBOutlet weak var goalsWidget: ArrowPickerWidget!
    
    
  
    @IBOutlet weak var timeWidget: ArrowPickerWidget!
    @IBOutlet weak var settingsScrollView: UIScrollView!
    
    @IBOutlet weak var chooseThemeButton: UIButton!
    @IBOutlet weak var restoreDefaultsButton: UIButton!
    
    var settingsProfile : SettingsProfile!
    
    private var isQuestionSet = false
    private var questionButton : UIButton!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController!.navigationBar.hidden = false
        self.navigationController!.navigationBar.topItem!.title = "Cancel"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaultPuckSize = defaultSettings.getPuckRadius()!
        println(chooseThemeButton.frame.origin)
        
        
        
        puckRadiusWidget.titleLabel.text = "Puck Size"
        puckRadiusWidget.values = sizes
        p1PaddleRadiusWidget.titleLabel.text = "P1 Paddle Size"
        p1PaddleRadiusWidget.values = sizes
        p2PaddleRadiusWidget.titleLabel.text = "P2 Paddle Size"
        p2PaddleRadiusWidget.values = sizes
        frictionWidget.titleLabel.text = "Friction"
        frictionWidget.values = frictions
        powerupsEnabledWidget.titleLabel.text = "Powerups"
        powerupsEnabledWidget.values = powerupBools
        goalsWidget.titleLabel.text = "Goals To Win"
        goalsWidget.values = goals
        timeWidget.titleLabel.text = "Time Limit"
        timeWidget.values = times
        p1PaddleColorWidget.titleLabel.text = "P1 Paddle Color"
        p1PaddleColorWidget.values = colors
        p2PaddleColorWidget.titleLabel.text = "P2 Paddle Color"
        p2PaddleColorWidget.values = colors
        setWidgetsFromSettings(settingsProfile)

        
        
        settingsScrollView.contentSize = CGSize(width: settingsScrollView.contentSize.width, height: restoreDefaultsButton.frame.origin.y + restoreDefaultsButton.frame.height)
        
        AirHockeyConstants.loadThemeChooser()
        Util.applyBackgroundToView(self.view)
        settingsScrollView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        
        
    }
    override func viewDidLayoutSubviews() {
        
        if !isQuestionSet {
            isQuestionSet = true
            
            let questionMarkSize = powerupsEnabledWidget.titleLabel.frame.height
            
            
            
            questionButton = UIButton(frame: CGRect(origin: CGPoint(x: powerupsEnabledWidget.frame.width - (questionMarkSize), y: 5), size: CGSize(width: questionMarkSize, height: questionMarkSize)))
            
            let image = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("questionMarkIcon.png")
            questionButton.setBackgroundImage(UIImage(contentsOfFile: image), forState: UIControlState.Normal)
            questionButton.addTarget(self,action: "powerupQuestionPressed:",forControlEvents: .TouchUpInside)
            powerupsEnabledWidget.arrowPickerView.addSubview(questionButton)
        } else {
            
            let questionMarkSize = powerupsEnabledWidget.titleLabel.frame.height

            
            questionButton.frame = CGRect(origin: CGPoint(x: powerupsEnabledWidget.frame.width - (questionMarkSize), y: 5), size: CGSize(width: questionMarkSize, height: questionMarkSize))
            
           
        }
        settingsScrollView.contentSize = CGSize(width: settingsScrollView.contentSize.width, height: restoreDefaultsButton.frame.origin.y + restoreDefaultsButton.frame.height)
    }
    
    
    func powerupQuestionPressed(button : UIButton!) {
        self.performSegueWithIdentifier("PowerupTutorialSegue", sender: self)
    }
   
    
    
    func setWidgetsFromSettings(settings : SettingsProfile) {
        puckRadiusWidget.setItem(settings.getPuckRadiusValue()!)
        p1PaddleRadiusWidget.setItem(settings.getPlayerOnePaddleRadiusValue()!)
        p2PaddleRadiusWidget.setItem(settings.getPlayerTwoPaddleRadiusValue()!)
        frictionWidget.setItem(settings.getFrictionValue()!)
        if (settings.arePowerupsEnabled()!) {
            powerupsEnabledWidget.setItem(0)
        } else {
            powerupsEnabledWidget.setItem(1)
        }
        goalsWidget.setItem(settings.getGoalLimit()!)
       
        timeWidget.setItem(settings.getTimeLimit()!/60)
        
        p1PaddleColorWidget.setItem(settings.getPlayerOnePaddleColorNumber()!)
        p2PaddleColorWidget.setItem(settings.getPlayerTwoPaddleColorNumber()!)

    }
    
    func setProfileFromWidgets() {
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
        settingsProfile.setPlayerOnePaddleColor(p1PaddleColorWidget.currentIndex)
        settingsProfile.setPlayerTwoPaddleColor(p2PaddleColorWidget.currentIndex)
        
    }
    
    @IBAction func saveSettings(sender: UIButton) {
        
        setProfileFromWidgets()
        SoundManager().playButtonPressedSound()

        Settings.updateSettingsProfile(settingsProfile)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
  
    @IBAction func restoreDefaults(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        setWidgetsFromSettings(AirHockeyConstants.getDefaultSettings())
        
    }
    
    
    @IBAction func chooseThemePressed(sender: UIButton) {
        let destination = themeChooser
        SoundManager().playButtonPressedSound()

        themeChooser.settingsProfile=settingsProfile
        self.navigationController!.pushViewController(themeChooser, animated: true)        
    }
}