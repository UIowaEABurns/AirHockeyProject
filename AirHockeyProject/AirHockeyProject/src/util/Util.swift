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
    
    
    
    class func applyBackgroundToView(view : UIView) {
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("splash.png"))
        
        var imageView = UIImageView(image: image)
        imageView.frame.size = view.frame.size
        imageView.alpha = 0.6
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
}