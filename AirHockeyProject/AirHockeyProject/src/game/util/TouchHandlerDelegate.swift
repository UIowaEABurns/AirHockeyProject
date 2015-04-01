//
//  TouchHandlerDelegate.swift
//  AirHockeyProject
//
//  Created by divms on 4/1/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation

public protocol TouchHandlerDelegate {
    func activate()
    func inactivate()
    func isActive() -> Bool
    func handleTouches(touches: NSSet)
}