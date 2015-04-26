//
//  PlayerSelectEventDelegate.swift
//  AirHockeyProject
//
//  Created by divms on 4/20/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

public protocol PlayerSelectEventDelegate {
    func readySelected()
    func backSelected()
    func settingsSelected(settings : SettingsProfile)
    func handleLoginChange()
}