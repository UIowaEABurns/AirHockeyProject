//
//  PowerupsViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/29/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class PowerupsViewController : UIViewController {
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        Util.applyBackgroundToView(self.view)
    }
}