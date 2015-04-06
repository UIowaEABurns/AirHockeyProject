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
public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //TODO: need to pass the user setting profile to this variable
    public var settingsProfile = AirHockeyConstants.getDefaultSettings()
    public var userOne : User? // TODO: These need to be set by the previous screen
    
    public var userTwo : User?
    
    public var theme : Theme = Theme(name: "classic", font: "Digital-7Mono")
    
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
        let pauseButtonSize = CGSize(width: ((1-TABLE_WIDTH_FRACTION)/2) * self.frame.width, height: ((1-TABLE_HEIGHT_FRACTION)/2.5) * self.frame.height)
        
        
        pauseButton  = Button(fontNamed: theme.fontName, block: {self.pauseGame()}, s : pauseButtonSize)
        pauseButton.setText("Pause")
        pauseButton.name = "pause"
    
        pauseButton.position = CGPoint(x: self.frame.minX+5, y: self.frame.minY+5)
        touchHandlers.append(pauseButton)
        
        
        gameplayNode.addChild(pauseButton)
        
        
        resumeButton = Button(fontNamed: theme.fontName, block: {self.resumeGame()}, s: pauseButtonSize)
        resumeButton.inactivate()
        resumeButton.setText("Resume")
        resumeButton.name="resume"
        resumeButton.position = CGPoint(x: overlayNode.frame.midX-(resumeButton.frame.width/2), y: overlayNode.frame.midY)
        touchHandlers.append(resumeButton)
        overlayNode.addChild(resumeButton)
        
    }
    
    public func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.node == nil || contact.bodyB.node == nil) {
            return
        }
        if (contact.bodyA.node!.name == PUCK_NAME || contact.bodyB.node!.name == PUCK_NAME) {
            EffectManager.runSparkEffect(contact.contactPoint, parent: self)
        }
    }
    
    
    override public func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if (!contentCreated) {
            println("console")
            self.physicsWorld.gravity=CGVectorMake(0,0) // no gravity in this game
            self.physicsWorld.contactDelegate = self
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
            if (!(userOne==nil)) {
                playerOne=HumanPlayer(i: 1,input: inputManager,p: playingTable)

            } else {
                settingsProfile.getAIDifficulty()
                playerOne=HumanPlayer(i: 1,input: inputManager,p: playingTable)

                //playerOne=AIPlayer(diff: settingsProfile.getAIDifficulty()!, i: 1,input: inputManager,p: playingTable)

            }
            if !(userTwo==nil) {
                playerTwo=HumanPlayer(i: 2, input: inputManager,p: playingTable)

            } else {
                playerTwo=HumanPlayer(i: 2,input: inputManager,p: playingTable)

                //playerTwo=AIPlayer(diff: settingsProfile.getAIDifficulty()!, i: 2, input: inputManager,p: playingTable)

            }
            
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
        
            
            let timerSize = CGSize(width: (1-TABLE_WIDTH_FRACTION)/2 * self.frame.width * 1.4, height: self.size.height * 0.1)
            timer = GameTimer(seconds: Int64(settingsProfile.getTimeLimit()!),font : theme.fontName!, size: timerSize)
            
            
            timer.position = CGPointMake(CGRectGetMaxX(self.frame)-timer.frame.width-5,CGRectGetMidY(self.frame)-(timer.frame.height/2))
            println(timerSize)
            println(timer.position)
            timer.zPosition = zPositionTimer
            gameplayNode.addChild(timer)
            timer.timer.start()
        
            playerOneScore = SKLabelNode(fontNamed: theme.fontName)
            playerOneScore.zPosition = zPositionTimer
            playerOneScore.fontSize = timer.getFontSize()
            playerOneScore.zRotation = CGFloat((M_PI*3.0)/2.0)
            playerOneScore.text = "0"
            playerOneScore.position = CGPoint(x: timer.position.x , y: timer.position.y - playerOneScore.frame.height - SCORE_DISPLAY_PADDING)
            playerTwoScore = SKLabelNode(fontNamed: theme.fontName)
            playerTwoScore.zRotation = CGFloat((M_PI*3.0)/2.0)
            playerTwoScore.text = "0"
            playerTwoScore.fontSize = timer.getFontSize()
            playerTwoScore.zPosition = zPositionTimer
            playerTwoScore.position = CGPoint(x: timer.position.x , y: timer.position.y + (playerOneScore.frame.height) + timer.frame.height + SCORE_DISPLAY_PADDING)
            gameplayNode.addChild(playerOneScore)
            gameplayNode.addChild(playerTwoScore)
            
            var effectOverlay = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.frame.width, height: self.frame.height)))
            
            effectOverlay.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
            effectOverlay.zPosition = zPositionEffectOverlay
            effectOverlay.fillColor = SKColor.clearColor()
            effectOverlay.name = TABLE_EFFECT_OVERLAY_NAME
            gameplayNode.addChild(effectOverlay)
            
            overlayNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.frame.width, height: self.frame.height)))
            
            overlayNode.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
            overlayNode.zPosition = zPositionOverlay
            overlayNode.fillColor = OVERLAY_COLOR
            overlayNode.hidden = true
            self.addChild(overlayNode)
            
            
            let bgNode = SKSpriteNode(imageNamed: theme.boardName+"Background.jpg")
            bgNode.size = self.frame.size
            bgNode.anchorPoint = CGPoint(x: 0,y: 0)
            bgNode.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
            bgNode.zPosition = zPositionBackground
            //self.addChild(bgNode)
            
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
        var table : Table = Table(imageNamed: theme.boardName+"Table.png")
        table.configureTable(rect, goalWidthRatio: 0.30)
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
        var puck : Puck = Puck(imageNamed: theme.boardName+"Puck.png")
        
        puck.size = CGSize(width: radius * 2, height: radius * 2)
        
        puck.configurePuck(density, settingsProfile: settingsProfile)
        return puck
    }
    
    
    //returns a paddle TODO get a textured node
    func getPaddleSprite(r : CGFloat, mass : CGFloat)-> Paddle{
        var paddle = Paddle(imageNamed: theme.boardName+"Paddle.png")
        
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
    
    
    
    //handles a goal being scored on the given player
    private func handleGoalScored(playerScoredOn : Int) {
        if (playerScoredOn==1) {
            playerTwo.score=playerTwo.score+1
            
        } else {
            playerOne.score=playerOne.score+1
        }
        playingTable.resetPuckToPlayer(playerScoredOn)
        playerOneScore.text = String(playerOne.score)
        playerTwoScore.text = String(playerTwo.score)
        EffectManager.runFlashEffect(gameplayNode.childNodeWithName(TABLE_EFFECT_OVERLAY_NAME)! as SKShapeNode,originalColor: SKColor.clearColor(), flashColor: SKColor.whiteColor())
    }
    
   
    
    //TODO: Refactor these tasks to somewhere else?
    override public func update(currentTime: CFTimeInterval) {
        if (!gameplayNode.paused) {
            playerOne.getPaddle()!.lastPosition = playerOne.getPaddle()!.position
            playerTwo.getPaddle()!.lastPosition = playerTwo.getPaddle()!.position
            playerOne.movePaddle()
            playerTwo.movePaddle()
            let puck = self.playingTable.getPuck()
            var goalScored = false
            
            playingTable.enumerateChildNodesWithName(GOAL_NAME, usingBlock: {
                (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                let goal = node as Goal
                if (Geometry.nodeContainsNode(goal, innerNode: self.playingTable.getPuck())) {
                    goal.handleGoalScored()
                    self.handleGoalScored(goal.getPlayerNumber())
                    
                }
            
            
            })
            
            
            
            
            
        }
        
    }
   override public func didSimulatePhysics() {
        playerOne.processPaddlePosition()
        playerTwo.processPaddlePosition()
        if (Geometry.magnitude(playingTable.getPuck().physicsBody!.velocity) > MAX_PUCK_SPEED) {
            playingTable.getPuck().physicsBody!.velocity = Geometry.getVectorOfMagnitude(playingTable.getPuck().physicsBody!.velocity, b: MAX_PUCK_SPEED)
        
        }
        for paddle in [playerOne.getPaddle()!, playerTwo.getPaddle()!] {
            if !playingTable.containsPoint(self.convertPoint(paddle.position, fromNode: playingTable)) {
               
                paddle.position = paddle.lastPosition!
            }
        }
        let framePosition = self.convertPoint(playingTable.getPuck().position, fromNode: playingTable)
        if framePosition.x<self.frame.minX - 100 || framePosition.x>self.frame.maxX + 100 || framePosition.y<self.frame.minY-300 || framePosition.y>self.frame.maxY+300 {
            playingTable.centerPuck()

        }
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
