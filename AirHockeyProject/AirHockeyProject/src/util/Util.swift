//
//  Util.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

let SwipeDelegate = Util()
class Util : NSObject, UIGestureRecognizerDelegate {
    
    class func getCurrentTimeMillis() -> Int64 {
        let date = NSDate().timeIntervalSince1970*1000
        return Int64(date)
    }
    
    class func stringToLongInt(s : String) -> Int64 {
        let nsString = s as NSString
        
        
        return nsString.longLongValue
        
        
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    /*
        returns a string representing time as hours:minutes:seconds
    */
    class func getTimeString(seconds : Int) -> String {
        if (seconds<=0) {
            return "0:00:00"
        }
        let hours = seconds / ( 60 * 60 )
        
        
        var secondsRemaining = seconds - (hours * 60 * 60)
        
        
        let minutes = secondsRemaining/60
        
        secondsRemaining=secondsRemaining-(minutes*60)
        
        var secondsString = String(secondsRemaining)
        var minutesString = String(minutes)
        if (count(secondsString)==1) {
            secondsString="0"+secondsString
        }
        if (count(minutesString)==1) {
            minutesString="0"+minutesString
        }
        return String(hours)+":"+minutesString+":"+secondsString
        
    }
    
    
    class func styleNavBar(controller : UINavigationController?) {
        if let c = controller {
            c.navigationBar.translucent = true
            c.navigationBar.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
            c.navigationBar.barTintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
        }
    }
    
    class func applyBackgroundToView(view : UIView) {
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("menuBackground.png"))
        
        var imageView = UIImageView(image: image)
        var blackView = UIView(frame: view.frame)
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.35
        imageView.frame.size = view.frame.size
        imageView.alpha = 1
        view.addSubview(blackView)
        view.addSubview(imageView)
        view.sendSubviewToBack(blackView)

        view.sendSubviewToBack(imageView)
    }
    
}