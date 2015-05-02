//
//  InputManager.swift
//  AirHockeyProject
//
//  Created by divms on 3/28/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import SpriteKit
// this class takes in all the touches that the game has seen and parses them into inputs for player one and player two
public class InputManager {
    // these points are with relation to the playing surface
    private var p1TouchLocation : CGPoint?
    private var p2TouchLocation : CGPoint?
    
    private var finalP1TouchLocation : CGPoint?
    private var finalP2TouchLocation : CGPoint?
    
    private var playingTable : Table

    
    private var p1Touch : AnyObject?
    private var p2Touch : AnyObject?
    
    init(t : Table) {
        playingTable = t
    }

    private func sameTouch(a : CGPoint?, b : CGPoint?)-> Bool {
        if (a==nil || b==nil) {
            return false
        }
        
        return (a!.x==b!.x && a!.y==b!.y)
    }
    
    
    private func printTouch(touch : AnyObject) {
        if touch.phase! == UITouchPhase.Began {
            println("began")
        } else if touch.phase!==UITouchPhase.Moved {
            println("moved")
        } else if touch.phase!==UITouchPhase.Stationary {
            println("stationary")
        } 
    }
    public func updateTouches(touches: NSSet){
        
        //p1TouchLocation = nil
        //p2TouchLocation = nil
        finalP1TouchLocation = nil
        finalP2TouchLocation = nil
        let p1Half=playingTable.getPlayerOneHalf()
        let p2Half=playingTable.getPlayerTwoHalf()
        for touch: AnyObject in touches {
            
            if (touch.phase!==UITouchPhase.Ended ||  touch.phase==UITouchPhase.Cancelled) {
                if touch===p1Touch {
                    p1TouchLocation = nil
                    p1Touch=nil
                }
                if touch===p2Touch {
                    p2Touch = nil
                    p2TouchLocation = nil
                }
            }
        }
        for touch : AnyObject in touches {
            if (touch.phase!==UITouchPhase.Ended ||  touch.phase==UITouchPhase.Cancelled) {
                continue //ignore this touch, it is ending or cancelled
            }
        
            //printTouch(touch)
            let location = touch.locationInNode(playingTable)
          
            if (touch.phase!==UITouchPhase.Moved) {
                let prevLocation = touch.previousLocationInNode(playingTable)
                
                if (touch===p1Touch) {
                    p1TouchLocation = location
                    continue
                } else if (touch===p2Touch) {
                    p2TouchLocation = location
                    continue
                }
            }
            
            
            
            
           
            
            if (p1Half.contains(location)) {
                if (p1TouchLocation==nil) {
                    p1TouchLocation=location
                    p1Touch = touch
                }

            } else if (p2Half.contains(location)) {
                if (p2TouchLocation==nil) {
                    p2TouchLocation=location
                    p2Touch = touch
                }
            }

        }
        if ((p1TouchLocation) != nil) {
            finalP1TouchLocation = Geometry.getNearestPointInRect(p1Half, point: p1TouchLocation!)
        }
        if ((p2TouchLocation) != nil) {
            finalP2TouchLocation = Geometry.getNearestPointInRect(p2Half, point: p2TouchLocation!)
        }
    }
    // given a player number, returns the input for that player
    public func getInputForPlayer(number : Int) -> CGPoint? {
        if (number==1) {
            return getPlayerOneInput()
            
        } else if (number==2) {
            return getPlayerTwoInput()
        }
        return nil
    }
    
    public func getPlayerOneInput() -> CGPoint?{
        return finalP1TouchLocation
    }
    
    public func getPlayerTwoInput() -> CGPoint? {
        return finalP2TouchLocation
    }
    

}