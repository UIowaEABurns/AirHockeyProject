//
//  Util.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation

class Util {
    
    class func getCurrentTimeMillis() -> Int64 {
        let date = NSDate().timeIntervalSince1970*1000
        return Int64(date)
    }
    
    class func stringToLongInt(s : String) -> Int64 {
        println("here")
        let nsString = s as NSString
        println(nsString)
        
        
        return nsString.longLongValue
    }
    
}