//
//  CreateNewViewController.swift
//  AirHockeyProject
//
//  Created by uics13 on 4/23/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class CreateNewViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    private var errorBorderWidth : CGFloat = 3
    private func validateUserCreation() -> Bool {
        let fn = FirstName.text
        let ln = LastName.text
        let u = Username.text
        FirstName.layer.borderWidth = 0
        LastName.layer.borderWidth = 0
        Username.layer.borderWidth = 0
        var success = true
        
        
        
        var errorMessage = ""
        var empty = false
        if fn.isEmpty {
            FirstName.layer.borderWidth = errorBorderWidth
            empty = true
            success = false
            errorMessage = errorMessage+"-- Please complete every field\n"
        }
        
        if ln.isEmpty {
            LastName.layer.borderWidth = errorBorderWidth
            
            if !empty {
                errorMessage = errorMessage+"-- Please complete every field\n"

            }
            
            empty = true
            success = false
            
        }
        
        if u.isEmpty {
            Username.layer.borderWidth = errorBorderWidth
            if !empty {
                errorMessage = errorMessage+"-- Please complete every field\n"
                
            }
            empty = true
            success = false

        } else if Users.getUserByUsername(u) != nil || u == "Guest" {
            Username.layer.borderWidth = errorBorderWidth

            errorMessage = errorMessage + "-- The username " + u + " is already taken"
            success = false

        } else if count(u) > 16 {
            Username.layer.borderWidth = errorBorderWidth
            errorMessage = errorMessage + "-- Usernames must be 16 characters or less"

            success = false
        }
        errorLabel.text = errorMessage
        return success
    }
    
    
    @IBAction func CreateButtonPressed(sender: UIButton) {
        SoundManager().playButtonPressedSound()

        
        
        
        if (validateUserCreation()) {
            var tempUser: User = User()
            tempUser.setFirstName(FirstName.text)
            tempUser.setLastName(LastName.text)
            tempUser.setUsername(Username.text)
            Users.createUser(tempUser)
            
            if userOneUsername == nil {
                Users.login(Users.getUserByUsername(tempUser.getUsername()!)!, playerOne: true)
            }
            
            self.navigationController!.popViewControllerAnimated(true)
        }
        
    }
    override func viewDidLoad() {
        self.navigationController!.navigationBar.hidden = false
        self.navigationController?.interactivePopGestureRecognizer.delegate = SwipeDelegate
        
        FirstName.layer.borderColor = UIColor.redColor().CGColor
        LastName.layer.borderColor = UIColor.redColor().CGColor
        Username.layer.borderColor = UIColor.redColor().CGColor
        
        FirstName.delegate = self
        LastName.delegate = self
        Username.delegate = self
        errorLabel.text = ""
        Util.applyBackgroundToView(self.view)
    }
    @IBAction func handleScreenTapped(sender: UITapGestureRecognizer) {
        
        FirstName.endEditing(true)
        LastName.endEditing(true)
        Username.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    
    
}