//
//  ReadyButtonView.swift
//  AirHockeyProject
//
//  Created by divms on 4/23/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

public class ReadyButtonView : UIView {
    @IBOutlet var buttonView: UIView!
    
    @IBOutlet weak var readyButton: UIButton!
    
    private var ready = false
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("ReadyButtonView", owner: self, options: nil)
        self.buttonView.bounds = self.bounds
        self.buttonView.frame.origin = CGPoint(x: 0, y: 0)
        self.buttonView.frame.size = self.frame.size
        self.backgroundColor = UIColor.clearColor()
        readyButton.clipsToBounds = true
        readyButton.layer.masksToBounds = true
        readyButton.layer.borderWidth = 2
        readyButton.layer.borderColor = UIColor.greenColor().CGColor
        readyButton.layer.cornerRadius = 10
        self.addSubview(self.buttonView)
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            readyButton.titleLabel!.font = readyButton.titleLabel!.font.fontWithSize(40)
        }
        readyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        
        
        
        styleButton()
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        setReady(!ready)
    }
    
    
    public func isReady() -> Bool {
        return ready
    }
    
    public func setReady(newVal : Bool) {
        ready = newVal
        styleButton()
    }
    
    func styleButton() {
        if ready {
            readyButton.backgroundColor = UIColor.greenColor()
            readyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
          
            let fontSize = getFontSizeToFitWidth("✓", size: readyButton.bounds.size, fontName: readyButton.titleLabel!.font.fontName)
            readyButton.titleLabel!.font = readyButton.titleLabel!.font.fontWithSize(fontSize)
            readyButton.setTitle("✓", forState: UIControlState.Normal)

        } else {
            readyButton.backgroundColor = UIColor.clearColor()
            let fontSize = getFontSizeToFitWidth("Ready", size: readyButton.bounds.size, fontName: readyButton.titleLabel!.font.fontName)
            readyButton.setTitle("Ready", forState: UIControlState.Normal)
            readyButton.titleLabel!.font = readyButton.titleLabel!.font.fontWithSize(fontSize)
            readyButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            


        }
    }
    
    private func getFontSizeToFitWidth(s : String, size : CGSize, fontName : String) -> CGFloat {
        // won't fit if it is empty, so just return 1
        if (s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty){
            return 1
        }
        var testSize : CGFloat = 1
        let temp : NSString = s
        while (testSize<150) {
            let dict = [NSFontAttributeName:UIFont(name: fontName, size: testSize)!]
            
            let curSize : CGSize = temp.sizeWithAttributes(dict)
            
            if (curSize.width>size.width || curSize.height>size.height) {
                break;
            }
            
            
            testSize = testSize + 2
        }
        return testSize - 2
    }
}