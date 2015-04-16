//
//  DatabaseManager.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
//import SQLite

public class DatabaseManager {
    
    class func getDatabasePath() -> NSString {
        var path : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as! NSString;
        
        path=path.stringByAppendingPathComponent("airhockeydatabase.sql")
        
        
        return path
    }
    
    class func getBaseDatabasePath() -> NSString {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("airhockey.sqlite3")
        

    }
    
    class func deleteAndRefreshDatabase() {
        let path=getDatabasePath()
        NSFileManager().removeItemAtPath(path as String, error: NSErrorPointer())
        setupDatabaseIfNotExists()
    }
    
    class func setupDatabaseIfNotExists() {
        var databasePath=getDatabasePath()
        
        let fileManager = NSFileManager()
        if (!fileManager.fileExistsAtPath(databasePath as String)) {
            let basePath=getBaseDatabasePath()
            fileManager.copyItemAtPath(basePath as String, toPath: databasePath as String, error: NSErrorPointer())
        }
    }
    
   
    
    
}