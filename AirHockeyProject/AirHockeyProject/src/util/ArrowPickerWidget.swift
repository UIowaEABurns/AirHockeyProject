//
//  ArrowPickerWidget.swift
//  AirHockeyProject
//
//  Created by divms on 4/23/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class ArrowPickerWidget : UIView {
    
    @IBOutlet var arrowPickerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    var values : [String] = ["test","two","three"]
    var currentIndex = 0
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("ArrowPickerWidget", owner: self, options: nil)
        self.arrowPickerView.bounds = self.bounds
        self.arrowPickerView.frame.origin = CGPoint(x: 0, y: 0)
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.arrowPickerView)
    }
    
    
    private func setText() {
        textLabel.text = values[currentIndex]
    }
    
    @IBAction func leftArrowPushed(sender: UIButton) {
        currentIndex = currentIndex - 1
        if currentIndex<0 {
            currentIndex = values.count - 1
        }
        SoundManager().playButtonPressedSound()
        setText()
    }
    @IBAction func rightArrowPressed(sender: UIButton) {
        currentIndex = (currentIndex + 1) % values.count
        SoundManager().playButtonPressedSound()

        setText()
    }
    
    // choose item index
    func setItem(item : Int) {
        currentIndex = item % values.count
        setText()
    }
    
}