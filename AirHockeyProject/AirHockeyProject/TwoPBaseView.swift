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
    
    @IBOutlet weak var readyButtonView: ReadyButtonView!
    @IBOutlet weak var baseScreenPlayerText: UILabel!
    @IBOutlet weak var readyScreenPlayerText: UILabel!
    
    @IBOutlet weak var gameSettingsButton: UIButton!
    private var currentScreen : UIView?
    private var eventDelegate : PlayerSelectEventDelegate!
    @IBOutlet weak var aiDifficultySelector: ArrowPickerWidget!
    
    @IBOutlet weak var homeButtonOne: UIButton!
    @IBOutlet weak var homeButtonTwo: UIButton!
    
    
    @IBOutlet var aiView: UIView!
    
    @IBOutlet weak var loginPickerView: UIPickerView!
    
    var pickerData : [String] = Users.getAllUsernamesExceptLogins()
    
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
        
        //on button press, remove then add new
        self.addSubview(self.Display)
        self.addSubview(ReadyDisplay)
        self.addSubview(LoginDisplay)
        self.addSubview(aiView)
        aiDifficultySelector.values = ["Easy", "Medium", "Hard"]
        aiDifficultySelector.setItem(1)
        aiDifficultySelector.titleLabel.text = "Difficulty"
        baseScreenPlayerText.text = "Player " + String(playerNumber)
        readyScreenPlayerText.text = user?.getUsername()
        readyButtonView.readyButton.addTarget(self, action: "readySwitched:", forControlEvents: .TouchUpInside)

        
        
        
        if (playerNumber == 2) {
            self.homeButtonOne.hidden = true
            self.homeButtonTwo.hidden = true
            self.gameSettingsButton.hidden = true
            user = Users.getPlayerLogin(false)
        } else {
            user = Users.getPlayerLogin(true)
        }
        if (user != nil) {
            settingsProfile = user!.getSettingsProfile()!
            readyScreenPlayerText.text = user!.getUsername()!
            switchScreensNoAnimation(ReadyDisplay)
            //readyButtonView.styleButton()

        }
    }
    func handleLayoutChange() {
        readyButtonView.styleButton()
    }
    
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        switchScreens(LoginDisplay)
    }
    @IBAction func GuestButtonPressed(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        user = AirHockeyConstants.getGuestUser()
        settingsProfile = AirHockeyConstants.getDefaultSettings()
        readyScreenPlayerText.text = "Guest"
        readyButtonView.styleButton()

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
        if currentScreen != nil {
            let fadeoutScreen = currentScreen
            UIView.animateWithDuration(0.3, animations: { fadeoutScreen!.alpha = 0 }, completion: {
                (finished) in
                
                
                
                fadeoutScreen!.hidden = true})
        }
        currentScreen = newScreen
    }
    
    func readySwitched(sender: AnyObject) {
        if readyButtonView.isReady() {
            eventDelegate.readySelected()
        }
    }
    @IBAction func BaseViewBackButtonPressed(sender: AnyObject) {
        SoundManager().playButtonPressedSound()

        eventDelegate.backSelected()
    
    }
    
    @IBAction func loginToAccount(sender: AnyObject) {
        let row = loginPickerView.selectedRowInComponent(0)
        SoundManager().playButtonPressedSound()
        if row == -1 {
            return
        } else if row >= pickerData.count {
            return
        }
        let username = pickerData[loginPickerView.selectedRowInComponent(0)]
        
        var loginAccount : User = Users.getUserByUsername(username)!
        func isUserOne () -> Bool {
            if playerNumber == 1 {return true}
            else {return false}
        }
        let x = Users.login(loginAccount, playerOne: isUserOne())
        if x {
            self.user = loginAccount
            self.settingsProfile = loginAccount.getSettingsProfile()!
            readyScreenPlayerText.text = user!.getUsername()!
            

            switchScreens(ReadyDisplay)
            readyButtonView.styleButton()
            self.eventDelegate.handleLoginChange()
        } else {
            //TODO: Handle a failed login
        }
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
        self.eventDelegate.handleLoginChange()
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
    
    
    func loadPickerData() {
        pickerData = Users.getAllUsernamesExceptLogins()
        loginPickerView.reloadAllComponents()

    }
    
    
}
