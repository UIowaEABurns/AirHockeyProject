//
//  GameScene.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import SpriteKit

// collision detection categories
let puckCategory :  UInt32 =  0x1 << 0;
let paddleCategory :  UInt32 =  0x1 << 1;
let edgeCategory : UInt32 = 0x1 << 2
let barrierCategory : UInt32 = 0x1 << 3
public class GameScene: SKScene {
    
    //TODO: need to pass the user setting profile to this variable
    private var settingsProfile = AirHockeyConstants.getDefaultSettings()

    private var inputManager : InputManager!
    
    private var playingTable : Table!
    private var playerOne : Player!
    private var playerTwo : Player!
    private var timer : GameTimer!
    private var gameplayNode : SKNode!
    private var defaultPhysicsSpeed : CGFloat!
    private var contentCreated : Bool = false
    private var gamePaused = false
    private var shouldRestoreToUnpaused = false
    
    private var playerOneScore : SKLabelNode!
    private var playerTwoScore : SKLabelNode!
    
    private var overlayNode : SKShapeNode! // just a transparent gray overlay that we can put over the game
    
    private var activeNode : SKNode!
    
    
    private var pauseButton : Button!
    private var resumeButton : Button!
    
    private var touchHandlers : [TouchHandlerDelegate] = []
    
    public func getPlayingTable() -> Table {
        return playingTable
    }

    override init(size: CGSize) {
        super.init(size: size)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // TODO : should save data here
    public func appEnteringBackground() {
        if (!self.isGamePaused()) {
            shouldRestoreToUnpaused = true
            self.pauseGame()
            
        } else {
            shouldRestoreToUnpaused = false

        }
    }
    
    public func appEnteringForeground() {
        
        if (shouldRestoreToUnpaused) {
            self.resumeGame()
        }
        shouldRestoreToUnpaused=false
    }
    
    private func addPauseButtons() {
        pauseButton  = Button(fontNamed: gameFont, block: {self.pauseGame()})
        pauseButton.setText("Pause")
        pauseButton.name = "pause"
    
        pauseButton.label.fontColor = SKColor.whiteColor()
        pauseButton.position = CGPoint(x: self.frame.minX+5, y: self.frame.minY+5)
        touchHandlers.append(pauseButton)
        
        
        gameplayNode.addChild(pauseButton)
        
        
        resumeButton = Button(fontNamed: gameFont, block: {self.resumeGame()})
        resumeButton.inactivate()
        resumeButton.setText("Resume")
        resumeButton.name="resume"
        resumeButton.label.fontColor = SKColor.whiteColor()
        resumeButton.position = CGPoint(x: overlayNode.frame.midX-(resumeButton.frame.width/2), y: overlayNode.frame.midY)
        touchHandlers.append(resumeButton)
        overlayNode.addChild(resumeButton)
        
    }
    
    
    
    override public func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if (!contentCreated) {
            println("console")
            self.physicsWorld.gravity=CGVectorMake(0,0) // no gravity in this game
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteringBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteringForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
            
            defaultPhysicsSpeed = self.physicsWorld.speed
            
            gameplayNode = SKNode()
            activeNode = gameplayNode
            self.addChild(gameplayNode)
            let fractionOfWidth : CGFloat = TABLE_WIDTH_FRACTION
            let fractionOfHeight : CGFloat = TABLE_HEIGHT_FRACTION
            let width = self.frame.width * fractionOfWidth
            let height = self.frame.height * fractionOfHeight
            
            let size = CGSize(width: width,height: height)
            
            playingTable = makeTable(CGRect(origin: CGPoint(x: 0,y: 0), size: size))
            
            playingTable.position = CGPoint(x: self.frame.width*((1-fractionOfWidth)/2), y: self.frame.height*((1-fractionOfHeight)/2))
            gameplayNode.addChild(playingTable)
            
            let boardWidth : CGFloat = playingTable.frame.width

            
            
            var puck = getPuckSprite(2.0, radius: boardWidth*CGFloat(settingsProfile.getPuckRadius()!))
            playingTable.setPuck(puck)
            
            
            
            
            inputManager = InputManager(t: playingTable)
            playerOne=AIPlayer(speed: maxHumanPaddleSpeed, accel: maxHumanPaddleAcceleration, i: 1,input: inputManager,p: playingTable)
            playerTwo=AIPlayer(speed: maxHumanPaddleSpeed, accel: maxHumanPaddleAcceleration, i: 2, input: inputManager,p: playingTable)
            
            var paddle = getPaddleSprite(boardWidth*CGFloat(settingsProfile.getPlayerOnePaddleRadius()!), mass : puck.physicsBody!.mass * paddlePuckMassRatio)
            var tableHalf = playingTable.getPlayerOneHalf()
            
            paddle.position = CGPoint(x:CGRectGetMidX(tableHalf),y:CGRectGetMidY(tableHalf))
            playingTable.addChild(paddle)
            playerOne.setPaddle(paddle)
            
            
            paddle = getPaddleSprite(boardWidth*CGFloat(settingsProfile.getPlayerTwoPaddleRadius()!),mass : puck.physicsBody!.mass * paddlePuckMassRatio)
            tableHalf = playingTable.getPlayerTwoHalf()
            
            paddle.position = CGPoint(x:CGRectGetMidX(tableHalf),y:CGRectGetMidY(tableHalf))
            playingTable.addChild(paddle)
            playerTwo.setPaddle(paddle)
        
            
            
            
            timer = GameTimer(seconds: Int64(settingsProfile.getTimeLimit()!),font : gameFont)
            
            
            timer.position = CGPointMake(CGRectGetMaxX(self.frame)-timer.frame.width-5,CGRectGetMidY(self.frame))
            
            gameplayNode.addChild(timer)
            timer.timer.start()
        
            playerOneScore = SKLabelNode(fontNamed: gameFont)
            playerOneScore.zRotation = CGFloat((M_PI*3.0)/2.0)
            playerOneScore.text = "0"
            playerOneScore.position = CGPoint(x: timer.position.x , y: timer.position.y - playerOneScore.frame.height - SCORE_DISPLAY_PADDING)
            playerTwoScore = SKLabelNode(fontNamed: gameFont)
            playerTwoScore.zRotation = CGFloat((M_PI*3.0)/2.0)
            playerTwoScore.text = "0"
            playerTwoScore.position = CGPoint(x: timer.position.x , y: timer.position.y + playerOneScore.frame.height + SCORE_DISPLAY_PADDING)
            gameplayNode.addChild(playerOneScore)
            gameplayNode.addChild(playerTwoScore)
            
            
            overlayNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.frame.width, height: self.frame.height)))
            
            overlayNode.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
            overlayNode.zPosition = zPositionOverlay
            overlayNode.fillColor = OVERLAY_COLOR
            overlayNode.hidden = true
            self.addChild(overlayNode)
            self.addPauseButtons()
            
            
        }
        
        
        
    }
    
    public func pauseGame() {
        gameplayNode.paused=true
        overlayNode.hidden = false
        self.getTimer()!.timer.pause()
        self.physicsWorld.speed=0.0
        self.gamePaused=true
        activeNode = overlayNode
        pauseButton.inactivate()
        resumeButton.activate()
    }
    
    public func resumeGame() {
        println("calling resume")
        gameplayNode.paused = false
        overlayNode.hidden = true
        self.getTimer()!.timer.unpause()
        self.physicsWorld.speed = defaultPhysicsSpeed
        self.gamePaused=false
        activeNode = gameplayNode
        pauseButton.activate()
        resumeButton.inactivate()
    }
    
    public func exitGame() {
        //TODO: this needs to roll back to the previous screen
    }
    
    private func makeTable(rect: CGRect) -> Table {
        // TODO: goal width should be configurable
        var table = Table(rect: rect, goalWidthRatio: 0.30)
        
        
        
        return table
    }
    
    private func handleTouches(touches: NSSet) {
        inputManager.updateTouches(touches)
        for item in touchHandlers {
            if (item.isActive()) {
                item.handleTouches(touches)
            }
        }

    }
    
    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        handleTouches(touches)
    }
    
   override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    handleTouches(touches)

    }
    
    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        handleTouches(touches)

    }
    override public func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        handleTouches(touches)

    }
    
    
    
    //TODO: we actually want a textured node here, but this is just for testing
    func getPuckSprite(density : CGFloat, radius : CGFloat) -> Puck {
        var puck = Puck(circleOfRadius : radius)
        
        puck.configurePuck(density, settingsProfile: settingsProfile)
        return puck
    }
    
    
    //returns a paddle TODO get a textured node
    func getPaddleSprite(r : CGFloat, mass : CGFloat)-> Paddle{
        var paddle = Paddle(circleOfRadius : r)
        
        paddle.configurePaddle(r, settingsProfile: settingsProfile, mass : mass)
        return paddle
    }
    
    
    override public func didEvaluateActions() {
        if (!gameplayNode.paused) {
            // ensure player paddles are not going faster than the maximum
            for player in [playerOne, playerTwo] {
                let paddle=player.getPaddle()!
                var paddleSpeed = Geometry.magnitude(player.getPaddle()!.physicsBody!.velocity)
                if (paddleSpeed>player.getMaxSpeed()) {
                    paddle.physicsBody!.velocity = Geometry.getVectorOfMagnitude(paddle.physicsBody!.velocity, b: player.getMaxSpeed())
                }
            }
        }
    }
    
    
    //handles a goal being scored by the given player
    private func handleGoalScored(playerScoredOn : Int) {
        if (playerScoredOn==1) {
            playerTwo.score=playerTwo.score+1
            
        } else {
            playerOne.score=playerOne.score+1
        }
        playingTable.resetPuckToPlayer(playerScoredOn)
        playerOneScore.text = String(playerOne.score)
        playerTwoScore.text = String(playerTwo.score)
    }
    
   
    
    //TODO: Refactor these tasks to somewhere else?
    override public func update(currentTime: CFTimeInterval) {
        if (!gameplayNode.paused) {
            playerOne.movePaddle()
            playerTwo.movePaddle()
            
            playingTable.enumerateChildNodesWithName(GOAL_NAME, usingBlock: {
                (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                let goal = node as Goal
                if (Geometry.nodeContainsNode(goal, innerNode: self.playingTable.getPuck())) {
                    
                    self.handleGoalScored(goal.getPlayerNumber())
                    
                }
            
            
            })
            
            
            
        }
        
    }
   override public func didSimulatePhysics() {
    
    }
    
    public func getInputManager() -> InputManager {
        return inputManager
    }
    
    public func getPlayerOnePaddle() -> Paddle {
        return playerOne.getPaddle()!
    }
    
    public func getPlayerTwoPaddle() -> Paddle {
        return playerTwo.getPaddle()!
    }
    
    public func getTimer() -> GameTimer? {
        return timer
    }
    public func isGamePaused() -> Bool {
        return gamePaused
    }
}
