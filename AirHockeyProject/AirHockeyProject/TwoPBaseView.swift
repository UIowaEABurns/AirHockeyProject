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
    @IBOutlet weak var BackButton: UIButton!
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
    
    
    @IBOutlet var aiView: UIView!
    
    @IBOutlet weak var LoginPickerView: UIPickerView!
    
    let pickerData = Users.getAllUsernames()
    
    //LoginPickerView.dataSource = self
    //LoginPickerView.delegate = self
    
    var user : User?
    var settingsProfile : SettingsProfile?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, playerNumber : Int, eventDelegate : PlayerSelectEventDelegate) {
        self.eventDelegate = eventDelegate
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
        if (playerNumber == 2) {
            self.BackButton.hidden = true
            self.gameSettingsButton.hidden = true
        }
        LoginPickerView.dataSource = self
        LoginPickerView.delegate = self
    }
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        
        switchScreens(LoginDisplay)
    }
    @IBAction func GuestButtonPressed(sender: AnyObject) {
        user = AirHockeyConstants.getGuestUser()
        settingsProfile = AirHockeyConstants.getDefaultSettings()
        switchScreens(ReadyDisplay)
    }
    @IBAction func CancelLoginButton(sender: AnyObject) {
        switchScreens(Display)
    }
    
    @IBAction func BackReadyViewButton(sender: AnyObject) {
        user = nil
        settingsProfile = nil
        switchScreens(Display)
        readySwitch.setOn(false, animated: false)
    }
    
    
    private func switchScreens(newScreen : UIView) {
        newScreen.hidden = false
        if currentScreen != nil {
            currentScreen!.hidden = true
        }
        currentScreen = newScreen
    }
    
    @IBAction func readySwitched(sender: AnyObject) {
        if readySwitch.on {
            eventDelegate.readySelected()
        }
    }
    @IBAction func BaseViewBackButtonPressed(sender: AnyObject) {
        eventDelegate.backSelected()
    
    }
    
    
    @IBAction func gameSettingsSelected(sender: AnyObject) {
        eventDelegate.settingsSelected(settingsProfile!)
    }
    
    func setToAIScreen() {
        self.user = nil
        switchScreens(aiView)
        self.readySwitch.setOn(true,animated: false)
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
