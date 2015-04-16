//
//  Timer.swift
//  AirHockeyProject
//
//  Created by divms on 3/27/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation

public class Timer {
    private var startTime : Int64? // the time that start was called, in millis
    private var totalPauseTime : Int64 // the total time we have spent in a paused state since the last call to start(). If we are currently paused, does not include the time in the current pause session!
    private var currentPauseTime : Int64? // if we are paused, this is the time we paused at
    
    private var timeLimit : Int64 // a convenience time limit. Makes it possible to use this timer as a countdown
    init() {
        totalPauseTime=0
        timeLimit=60
    }
    
    private func getCurrentTimeMillis() -> Int64 {
        let date = NSDate().timeIntervalSince1970*1000
        return Int64(date)
    }
    
    //starts the timer.
    func start() {
        currentPauseTime=nil
        startTime=self.getCurrentTimeMillis()
        totalPauseTime=0
    }
    
    func isStarted() -> Bool {
        return !(startTime==nil)
    }
    
    // pauses the timer, so that as far as the timer is concerned no time will pass until
    // unpause is called. Calling pause() while already paused does nothing
    func pause() {
        if (!isPaused()) {
            currentPauseTime=getCurrentTimeMillis()
        }
    }
    
   
    
    // does nothing if we are not currently in a paused state
    func unpause() {
        if (isPaused()) {
           totalPauseTime=totalPauseTime+(getCurrentTimeMillis()-currentPauseTime!)
           currentPauseTime = nil
        }
    }
    // returns true if this is currently paused and false otherwise
    func isPaused() -> Bool {
        return !(currentPauseTime==nil)
    }
    
    
    // gets the amount of time, in milliseconds, that this timer has been working since the last call
    // to start. Takes into account pausings
    private func getTimedMillis() -> Int64? {
        if (isStarted()) {
            if (!isPaused()) {
                
                return getCurrentTimeMillis() - (startTime! + totalPauseTime)

            } else {
                let cp = getCurrentTimeMillis()
                let cpt = cp - currentPauseTime!
                return cp - (startTime! + totalPauseTime + cpt)
            }
            
            
        }
        return nil
    }
    
    
    
    // gets the amount of time that has elapsed since start() was called last
    // if start() has never been called, then returns null
    func getElapsedTimeMillis()-> Int64? {
        if (!isStarted()) {
            return nil
        }
        
        return getTimedMillis()
    }
    
    //gets the amount of time that has elapsed in seconds
    func getElapsedTimeSeconds() -> Int64? {
        if (!isStarted()) {
            return nil
        }
        
        return getTimedMillis()!/1000
    }
    
    //returns a string like 1:47 to represent the amount of elapsed time in minutes and seconds
    func getElapsedTimeString() -> String? {
        if (!isStarted()) {
            return nil
        }
        
        let seconds = getTimedMillis()!/1000
        return timeToString(seconds)
        
        
    }
    // given a number of seconds, creates a string in the desired format
    private func timeToString(seconds : Int64) -> String {
        
        if (seconds<=0) {
            return "0:00"
        }
        
        let minutes = seconds/60
        
        let remainingSeconds=seconds-(minutes*60)
        
        var secondsString = String(remainingSeconds)
        
        if (count(secondsString)==1) {
            secondsString="0"+secondsString
        }
        
        return String(minutes)+":"+secondsString
    }
    
    
    //gets the time remaining (based on timeLimit) as a string like 1:21. Returns 0:00 if there is no
    // time left
    func getRemainingTimeString() -> String? {
        if (!isStarted()) {
            
            return timeToString(timeLimit)
        }
        
        var seconds = getTimedMillis()!/1000
        seconds = timeLimit-seconds
        return timeToString(seconds)
        
    }
    func getRemainingTimeSeconds() -> Int64 {
        if (!isStarted()) {
            return timeLimit
        }
        var seconds = getTimedMillis()!/1000
        seconds = timeLimit - seconds
        if (seconds < 0) {
            return 0
        }
        return seconds
    }
    // Ignored if i<=0. Sets the time limit for this timer, in seconds
    func setTimeLimit(i : Int64) {
        if (i>0) {
            timeLimit=i
        }
    }
    
    // get the time limit of this timer, in seconds
    func getTimeLimit() -> Int64 {
        return timeLimit
    }
    //returns true if the time elapsed has exceed the timeLimit and falseotherwise
    func isDone()->Bool? {
        if(!isStarted()) {
            return nil
        }
        var seconds = getTimedMillis()!/1000
        seconds = timeLimit-seconds
        return (seconds<=0) 
        
    }
    
}