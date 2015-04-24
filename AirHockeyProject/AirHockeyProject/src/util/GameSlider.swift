//
//  GameSlider.swift
//  AirHockeyProject
//
//  Created by divms on 4/23/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class GameSlider : UISlider {
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height - 5))
    }
}