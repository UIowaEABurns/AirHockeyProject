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
    
    
    private var game : GameScene!

    
    
    init() {
        
    }
    
    public func setGame(g : GameScene) {
        game=g
    }
    
    
    
    private func sameTouch(a : CGPoint?, b : CGPoint?)-> Bool {
        if (a==nil || b==nil) {
            return false
        }
        
        return (a!.x==b!.x && a!.y==b!.y)
    }
    
    
    public func updateTouches(touches: NSSet){
        let prevP1 = p1TouchLocation
        let prevP2=p2TouchLocation
        p1TouchLocation = nil
        p2TouchLocation = nil
        for touch: AnyObject in touches {
            if (touch.phase!==UITouchPhase.Ended ||  touch.phase==UITouchPhase.Cancelled) {
                continue //ignore this touch, it is ending or cancelled
            }
            let location = touch.locationInNode(game.getPlayingTable())
          
            if (touch.phase!==UITouchPhase.Moved) {
                let prevLocation = touch.previousLocationInNode(game.getPlayingTable())

                if (sameTouch(prevP1,b: prevLocation)) {
                    p1TouchLocation = location
                    continue
                } else if (sameTouch(prevP2, b: prevLocation)) {
                    p2TouchLocation = location
                    continue
                }
            }
            
            
            
            
            let p1Half=game.getPlayingTable().getPlayerOneHalf()
            let p2Half=game.getPlayingTable().getPlayerTwoHalf()
            
            if (p1Half.contains(location)) {
                if (p1TouchLocation==nil) {
                    p1TouchLocation=location
                } else {
                    if !(prevP1==nil) {
                        //if (Geometry.distance(location,b: prevP1!)<Geometry.distance(p1TouchLocation!,b: prevP1!)) {
                        //    p1TouchLocation=location
                        //}
                    }
                }

            } else if (p2Half.contains(location)) {
                if (p2TouchLocation==nil) {
                    p2TouchLocation=location

                } else {
                    if !(prevP2==nil) {
                        //if (Geometry.distance(location,b: prevP2!)<Geometry.distance(p1TouchLocation!,b: prevP2!)) {
                        //    p2TouchLocation=location
                        //}
                    }
                }
            }

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
        return p1TouchLocation
    }
    
    public func getPlayerTwoInput() -> CGPoint? {
        return p2TouchLocation
    }
    

}