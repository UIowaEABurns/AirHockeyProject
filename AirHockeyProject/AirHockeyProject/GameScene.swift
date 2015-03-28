//
//  GameScene.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene {
    
    //TODO: need to pass the user setting profile to this variable
    private var settingsProfile = AirHockeyConstants.getDefaultSettings()
    
    
    
    private var inputManager : InputManager!
    
    private var playingTable : Table!
    
    public func getPlayingTable() -> Table {
        return playingTable
    }
    
    private var puck : Puck!
    
    private var maxPaddleSpeed : CGFloat=200
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity=CGVectorMake(0,0) // no gravity in this game
        inputManager = InputManager()
        inputManager.setGame(self)
        let fractionOfWidth : CGFloat = 0.8 // how much of the screen should this take up?
        let fractionOfHeight : CGFloat = 0.9
        let width = self.frame.width * fractionOfWidth
        let height = self.frame.height * fractionOfHeight
        let size = CGSize(width: width,height: height)
        
        playingTable = makeTable(CGRect(origin: CGPoint(x: self.frame.width*((1-fractionOfWidth)/2), y: self.frame.height*((1-fractionOfHeight)/2)), size: size))
        
        self.addChild(playingTable)
        
       
        
        puck = getPuckSprite(10.0,density: 2.0)
        puck.position = CGPoint(x:CGRectGetMidX(playingTable.frame), y:CGRectGetMidY(playingTable.frame));
        playingTable.setPuck(puck)
        playingTable.addChild(puck)
        
    }
    
    
    private func makeTable(rect: CGRect) -> Table {
        var table = Table(rect: rect)
        
        
        
        return table
    }
    
    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        inputManager.updateTouches(touches)
        
    }
    
   override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        inputManager.updateTouches(touches)
    }
    
    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        inputManager.updateTouches(touches)
    }
    
    
    
    //TODO: we actually want a textured node here, but this is just for testing
    func getPuckSprite(radius : CGFloat, density : CGFloat) -> Puck {
        var puck = Puck(circleOfRadius : radius)
        puck.configurePuck(radius, density: density, settingsProfile: settingsProfile)
        return puck
    }
    
    
   
    override public func update(currentTime: CFTimeInterval) {
        // move the puck to the mouse
        if (!(inputManager.getPlayerOneInput()==nil)) {
           // println("moving the puck")
            var normalVector : CGVector = Geometry.normalVector(puck.position, b: inputManager.getPlayerOneInput()!)
            let speed : CGFloat = 30 //TODO: Acceleration needs to be based on the distance from the paddle to the touch
            normalVector.dx = normalVector.dx * speed
            normalVector.dy = normalVector.dy * speed
            puck.physicsBody?.applyForce(normalVector)
            
        }
    }
    
   override public func didSimulatePhysics() {
        // called after physics have been simulated
        // slow down the puck if it is close to the touch
    var puckSpeed  = Geometry.magnitude(puck.physicsBody!.velocity)
    if (puckSpeed>maxPaddleSpeed) {
        puck.physicsBody!.velocity = Geometry.getVectorOfMagnitude(puck.physicsBody!.velocity, b: maxPaddleSpeed)
        puckSpeed=maxPaddleSpeed
    }
    if (!(inputManager.getPlayerOneInput()==nil)) {
       // println("we are close to the touch!")
        let distance = Geometry.distance(inputManager.getPlayerOneInput()!,b: puck.position)
        if (distance<=5) {
            puck.physicsBody!.velocity = CGVector(dx: 0,dy: 0)

        } else if (distance<=puckSpeed) {
            puck.physicsBody!.velocity = Geometry.getVectorOfMagnitude(puck.physicsBody!.velocity, b: distance)
        }
        
        
    }
        puck.physicsBody?.velocity
    }
}
