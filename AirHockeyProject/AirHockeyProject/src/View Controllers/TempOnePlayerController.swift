//
//  TempOnePlayerController.swift
//  AirHockeyProject
//
//  Created by divms on 4/20/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class TempOnePlayerController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ShowGameSegue" {
            let game = segue.destinationViewController as! GameViewController
            
            game.playerOne = AirHockeyConstants.getGuestUser()
            game.settingsProfile = AirHockeyConstants.getDefaultSettings()
        }
    }
}