//
//  2PBaseView.swift
//  AirHockeyProject
//
//  Created by uics13 on 4/13/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit
class TwoPBaseView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //multiple of these displays
    
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet var LoginDisplay: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet var Display: UIView!
    @IBOutlet var ReadyDisplay: UIView!
    @IBOutlet weak var GuestButton: UIButton!
    
    @IBOutlet weak var baseScreenPlayerText: UILabel!
    @IBOutlet weak var readyScreenPlayerText: UILabel!
    
    @IBOutlet weak var gameSettingsButton: UIButton!
    private var currentScreen : UIView?
    private var eventDelegate : PlayerSelectEventDelegate!
    @IBOutlet weak var readySwitch: UISwitch!
    @IBOutlet weak var aiDifficultySelector: ArrowPickerWidget!
    
    @IBOutlet weak var homeButtonOne: UIButton!
    @IBOutlet weak var homeButtonTwo: UIButton!
    
    
    @IBOutlet var aiView: UIView!
    
    @IBOutlet weak var LoginPickerView: UIPickerView!
    
    let pickerData = Users.getAllUsernames()
    
    private var playerNumber : Int
    
    var user : User?
    
    var settingsProfile : SettingsProfile?
    required init(coder aDecoder: NSCoder) {
        self.playerNumber = 0
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, playerNumber : Int, eventDelegate : PlayerSelectEventDelegate) {
        self.eventDelegate = eventDelegate
        self.playerNumber = playerNumber
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("TwoPBaseView", owner: self, options: nil)
        NSBundle.mainBundle().loadNibNamed("LoginView", owner:self, options: nil)
        NSBundle.mainBundle().loadNibNamed("ReadyView", owner:self, options: nil)
        NSBundle.mainBundle().loadNibNamed("AIPlayerView", owner:self, options: nil)
        self.Display.frame.size = frame.size
        self.Display.bounds = self.bounds

        self.LoginDisplay.frame = Display.frame
        self.LoginDisplay.bounds = Display.bounds

        self.ReadyDisplay.frame = Display.frame
        self.ReadyDisplay.bounds = Display.bounds
        self.aiView.frame = Display.frame
        self.aiView.bounds = Display.bounds
        
        self.LoginDisplay.hidden = true
        self.ReadyDisplay.hidden = true
        self.aiView.hidden = true
        currentScreen = Display
        
        self.backgroundColor = UIColor.redColor()
        //on button press, remove then add new
        self.addSubview(self.Display)
        self.addSubview(ReadyDisplay)
        self.addSubview(LoginDisplay)
        self.addSubview(aiView)
        aiDifficultySelector.values = ["Easy", "Medium", "Hard"]
        aiDifficultySelector.setItem(1)
        baseScreenPlayerText.text = "Player " + String(playerNumber)
        readyScreenPlayerText.text = "Player " + String(playerNumber)
        
        LoginPickerView.dataSource = self
        LoginPickerView.delegate = self
        
        
        if (playerNumber == 2) {
            self.homeButtonOne.hidden = true
            self.homeButtonTwo.hidden = true
            self.gameSettingsButton.hidden = true
            user = Users.getPlayerLogin(false)
        } else {
            user = Users.getPlayerLogin(true)
        }
        if (user != nil) {
            switchScreens(ReadyDisplay)
        }
    }
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        switchScreens(LoginDisplay)
    }
    @IBAction func GuestButtonPressed(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        user = AirHockeyConstants.getGuestUser()
        settingsProfile = AirHockeyConstants.getDefaultSettings()
        switchScreens(ReadyDisplay)
    }
    @IBAction func CancelLoginButton(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        switchScreens(Display)
    }
    

    private func switchScreensNoAnimation(newScreen : UIView) {
        newScreen.hidden = false
        if currentScreen != nil {
            currentScreen!.hidden = true
        }
        currentScreen = newScreen
    }
    
    private func switchScreens(newScreen : UIView) {
        newScreen.alpha = 0
        newScreen.hidden = false
        
        UIView.animateWithDuration(0.3, animations: { newScreen.alpha = 1 } )
        //newScreen.hidden = false
        if currentScreen != nil {
            //currentScreen!.hidden = true
            let fadeoutScreen = currentScreen
            UIView.animateWithDuration(0.3, animations: { fadeoutScreen!.alpha = 0 }, completion: {
                (finished) in
                
                
                
                fadeoutScreen!.hidden = true})
        }
        currentScreen = newScreen
    }
    
    @IBAction func readySwitched(sender: AnyObject) {
        if readySwitch.on {
            eventDelegate.readySelected()
        }
    }
    @IBAction func BaseViewBackButtonPressed(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        eventDelegate.backSelected()
    
    }
    
    
    @IBAction func gameSettingsSelected(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        eventDelegate.settingsSelected(settingsProfile!)
    }
    
    
    @IBAction func logoutButton(sender: UIButton) {
        Users.logout(playerNumber == 1)
        self.user = nil
        settingsProfile = nil
        switchScreens(Display)
        SoundManager().playButtonPressedSound()

    }
    
    
    
    func setToAIScreen() {
        self.user = nil
        switchScreensNoAnimation(aiView)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        LoginLabel.text = pickerData[row]
    }
    
}
