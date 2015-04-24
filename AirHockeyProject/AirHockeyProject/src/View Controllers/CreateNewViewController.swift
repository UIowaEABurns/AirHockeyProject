//
//  CreateNewViewController.swift
//  AirHockeyProject
//
//  Created by uics13 on 4/23/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class CreateNewViewController : UIViewController {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Username: UITextField!
    
    @IBAction func HomePressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func CreateButtonPressed(sender: UIButton) {
        
        var tempUser : User! = User()
        tempUser.setFirstName(FirstName.text)
        tempUser.setLastName(LastName.text)
        tempUser.setUsername(Username.text)
        Users.createUser(tempUser)
        
    }
    override func viewDidLoad() {
        
    
        
        
        
    }
    
}