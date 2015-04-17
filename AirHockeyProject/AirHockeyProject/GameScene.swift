//
//  GameScene.swift
//  AirHockeyProject
//
//  Created by divms on 3/25/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import SpriteKit
import UIKit
// collision detection categories
let puckCategory :  UInt32 =  0x1 << 0;
let paddleCategory :  UInt32 =  0x1 << 1;
let edgeCategory : UInt32 = 0x1 << 2
let barrierCategory : UInt32 = 0x1 << 3
let powerupCategory : UInt32 = 0x1 << 4
let lightCategory : UInt32 = 0x1 << 0
let gravCategory : UInt32 = 0x1 << 0
public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //TODO: need to pass the user setting profile to this variable
    public var settingsProfile : SettingsProfile
    public var userOne : User? // TODO: These need to be set by the previous screen
    
    public var userTwo : User?
    
    public var theme : Theme
    
    private var inputManager : InputManager!
    public var navigationController : UINavigationController?
    private var playingTable : Table!
    public var soundManager : SoundManager
    init(size : CGSize, p1 : User?, p2 : User?, profile : SettingsProfile, sound: SoundManager, nav : UINavigationController?) {
        userOne = p1
        userTwo = p2
        soundManager = sound
        settingsProfile = profile
        theme = Themes.getThemeByName(settingsProfile.getThemeName()!)!
        navigationController = nav
        super.init(size: size)
    }
    
    
    private var playerOne : Player!
    private var playerTwo : Player!
    private var timer : GameTimer!
    private var gameplayNode : SKNode!
    private var defaultPhysicsSpeed : CGFloat!
    private var contentCreated : Bool = false
    private var gamePaused = false
    private var gameOver = false
    private var gameStarted = false
    private var shouldRestoreToUnpaused = false
    private var goNode : FittedLabelNode!
    private var playerOneScore : SKLabelNode!
    private var playerTwoScore : SKLabelNode!
    
    private var overlayNode : SKShapeNode! // just a transparent gray overlay that we can put over the game
    
    private var activeNode : SKNode!
    private var startupNode : GameTimer!
    private var bgNode : SKSpriteNode!
    private var pauseButton : Button!
    private var resumeButton : Button!
    private var exitButton : Button!
    private var touchHandlers : [TouchHandlerDelegate] = []
    
    
    private var powerup : Powerup?
    let powerupOdds : CGFloat = 0.002
    public func getPlayingTable() -> Table {
        return playingTable
    }

 
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // TODO : should save data here
    public func appEnteringBackground() {
        if (!self.isGamePaused() && !self.isGameConcluded()) {
            shouldRestoreToUnpaused = true
            self.pauseGame()
            
        } else {
            shouldRestoreToUnpaused = false

        }
        if (!self.isGameConcluded()) {
            if (playerOne is HumanPlayer) {
                let temp : HumanPlayer = (playerOne as! HumanPlayer)
                temp.handleGameExited(playerTwo.score, timePlayed: Int(timer.timer.getElapsedTimeSeconds()!))
            }
            if (playerTwo is HumanPlayer) {
                let temp : HumanPlayer = (playerTwo as! HumanPlayer)
                temp.handleGameExited(playerOne.score, timePlayed: Int(timer.timer.getElapsedTimeSeconds()!))
            }
        }
        
    }
    
    
    
    
    
    
    public func appEnteringForeground() {
        
        if (shouldRestoreToUnpaused) {
            self.resumeGame()
        }
        if (!self.isGameConcluded()) {
            if (playerOne is HumanPlayer) {
                let temp : HumanPlayer = (playerOne as! HumanPlayer)
                temp.handleGameResumed()
            }
            if (playerTwo is HumanPlayer) {
                let temp : HumanPlayer = (playerTwo as! HumanPlayer)
                temp.handleGameResumed()
            }
        }
        shouldRestoreToUnpaused=false
    }
    
    private func addPauseButtons() {
        let pauseButtonSize = CGSize(width: ((1-TABLE_WIDTH_FRACTION)/2) * self.frame.width, height: 0.03 * self.frame.height)
        
        
        pauseButton  = Button(fontNamed: theme.fontName, block: {self.pauseGame()}, s : pauseButtonSize)
        pauseButton.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        pauseButton.setText("Pause")
        pauseButton.name = "pause"
    
        pauseButton.position = CGPoint(x: self.frame.minX+5, y: self.frame.minY+5)
        touchHandlers.append(pauseButton)
        
        
        gameplayNode.addChild(pauseButton)
        
        let resumeButtonSize=CGSize(width: 0.3 * self.frame.width, height: 0.05 * self.frame.height)
        resumeButton = Button(fontNamed: theme.fontName, block: {self.resumeGame()}, s: resumeButtonSize)
        resumeButton.inactivate()
        resumeButton.setText("Resume")
        resumeButton.name="resume"
        resumeButton.position = CGPoint(x: overlayNode.frame.midX-(resumeButton.frame.width/2), y: overlayNode.frame.midY+(self.frame.height*0.1))
        resumeButton.zPosition = zPositionOverlay + 1
        exitButton  = Button(fontNamed: theme.fontName, block: {self.exitGame()}, s: resumeButtonSize)
        exitButton.setText("Exit")
        exitButton.name="exitButton"
        exitButton.inactivate()
        exitButton.setFontSize(resumeButton.getFontSize())
        exitButton.position = CGPoint(x: overlayNode.frame.midX-(resumeButton.frame.width/2), y: overlayNode.frame.midY-(self.frame.height*0.1))
        exitButton.zPosition = zPositionOverlay + 1

        touchHandlers.append(resumeButton)
        touchHandlers.append(exitButton)
        overlayNode.addChild(resumeButton)
        
        overlayNode.addChild(exitButton)
        
        
        let size = CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.6)
        goNode = FittedLabelNode(s: size, str: "")
        goNode.setTextNoResize("Go!")
        goNode.zPosition = zPositionStartTimer
        goNode.setFittedFontName(theme.fontName!)
        
        goNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
    }
    
    public func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.node == nil || contact.bodyB.node == nil) {
            return
        }
        if (contact.bodyA.node!.name == PUCK_NAME || contact.bodyB.node!.name == PUCK_NAME) {
            
            EffectManager.runSparkEffect(contact.contactPoint, parent: self)
            //puck colliding with paddle
            if (contact.bodyA.categoryBitMask == paddleCategory || contact.bodyB.categoryBitMask == paddleCategory) {
                soundManager.playPaddleClick(Geometry.distance(CGPoint(x: contact.bodyA.velocity.dx, y: contact.bodyA.velocity.dy), b: CGPoint(x: contact.bodyB.velocity.dx, y: contact.bodyB.velocity.dy)))
            } else if (contact.bodyA.categoryBitMask == edgeCategory || contact.bodyB.categoryBitMask == edgeCategory) {
                soundManager.playWallClick(Geometry.distance(CGPoint(x: contact.bodyA.velocity.dx, y: contact.bodyA.velocity.dy), b: CGPoint(x: contact.bodyB.velocity.dx, y: contact.bodyB.velocity.dy)))
            }
            
        } else if (contact.bodyA.node!.physicsBody!.categoryBitMask == powerupCategory || contact.bodyB.node!.physicsBody!.categoryBitMask == powerupCategory) {
            // some player touched a powerup
            var powerup : Powerup? = nil
            var player : Player? = nil
            if (contact.bodyA.node!.physicsBody!.categoryBitMask == powerupCategory) {
                powerup = (contact.bodyA.node!) as? Powerup
                let pNumber = ((contact.bodyB.node!) as! Paddle).getPlayerNumber()!
                player = getPlayerFromPlayerNumber(pNumber)
            } else {
                powerup = (contact.bodyB.node!) as? Powerup
                let pNumber = ((contact.bodyA.node!) as! Paddle).getPlayerNumber()!
                player = getPlayerFromPlayerNumber(pNumber)
            }
            
            powerup!.touched(player!)
        }
    }
    
    
    override public func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if (!contentCreated) {
            soundManager.loadSounds(theme)
            println("console")
            self.physicsWorld.gravity=CGVectorMake(0,0) // no gravity in this game
            self.physicsWorld.contactDelegate = self
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteringBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteringForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
            
            defaultPhysicsSpeed = self.physicsWorld.speed
            
            gameplayNode = SKNode()

            activeNode = gameplayNode
            self.addChild(gameplayNode)
            
            let width = self.frame.width * TABLE_WIDTH_FRACTION
            let height = self.frame.height * TABLE_HEIGHT_FRACTION
            println("table")
            println(self.frame.width)
            println(self.frame.height)
            
            let size = CGSize(width: width,height: height)
            
            playingTable = makeTable(CGRect(origin: CGPoint(x: 0,y: 0), size: size))
            playingTable.position = CGPoint(x: self.frame.width*((1-TABLE_WIDTH_FRACTION)/2), y: self.frame.height*((1-TABLE_HEIGHT_FRACTION)/2))
            gameplayNode.addChild(playingTable)
            
            var puck = getPuckSprite(2.0, radius: playingTable.frame.width*CGFloat(settingsProfile.getPuckRadius()!))
            playingTable.setPuck(puck)
            
            
            
            
            inputManager = InputManager(t: playingTable)
            if (!(userOne==nil)) {
                playerOne=HumanPlayer(i: 1,input: inputManager,p: playingTable,s: userOne?.getStats())

            } else {
                settingsProfile.getAIDifficulty()
                playerOne=HumanPlayer(i: 1,input: inputManager,p: playingTable,s: nil)

                //playerOne=AIPlayer(diff: settingsProfile.getAIDifficulty()!, i: 1,input: inputManager,p: playingTable)

            }
            if !(userTwo==nil) {
                playerTwo=HumanPlayer(i: 2, input: inputManager,p: playingTable, s: userTwo!.getStats())

            } else {
                playerTwo=HumanPlayer(i: 2,input: inputManager,p: playingTable, s: nil)

                //playerTwo=AIPlayer(diff: settingsProfile.getAIDifficulty()!, i: 2, input: inputManager,p: playingTable)

            }
            var radius = playingTable.frame.width*CGFloat(settingsProfile.getPlayerOnePaddleRadius()!)
           
            
            var paddle = getPaddleSprite(1,radius: radius, mass : puck.physicsBody!.mass * paddlePuckMassRatio)
            var tableHalf = playingTable.getPlayerOneHalf()
            
            paddle.position = CGPoint(x:CGRectGetMidX(tableHalf),y:CGRectGetMidY(tableHalf))
            playingTable.addChild(paddle)
            playerOne.setPaddle(paddle)
            
            radius = playingTable.frame.width*CGFloat(settingsProfile.getPlayerTwoPaddleRadius()!)

            paddle = getPaddleSprite(2,radius: radius,mass : puck.physicsBody!.mass * paddlePuckMassRatio)
            tableHalf = playingTable.getPlayerTwoHalf()
            
            paddle.position = CGPoint(x:CGRectGetMidX(tableHalf),y:CGRectGetMidY(tableHalf))
            playingTable.addChild(paddle)
            
            playerTwo.setPaddle(paddle)
        
            
            let timerSize = CGSize(width: (1-TABLE_WIDTH_FRACTION)/2 * self.frame.width * 1.4, height: self.frame.height * 0.1)

            timer = GameTimer(seconds: Int64(settingsProfile.getTimeLimit()!),font : theme.fontName!, size: timerSize, singleSecond: false)
            timer.zRotation = CGFloat((M_PI*3.0)/2.0)

            
            timer.position = CGPointMake(CGRectGetMaxX(self.frame)-timer.frame.width-5,CGRectGetMidY(self.frame)-(timer.frame.height/2))
            
            timer.zPosition = zPositionTimer
            gameplayNode.addChild(timer)
            if (settingsProfile.getTimeLimit()!==0) {
                timer.hidden = true // we won't be timing anything if the limit is 0
            }
            playerOneScore = getScoreLabelNode()
            playerOneScore.position = CGPoint(x: timer.position.x , y: timer.position.y - playerOneScore.frame.height - SCORE_DISPLAY_PADDING)
            
            playerTwoScore = getScoreLabelNode()
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
            
            bgNode = SKSpriteNode(imageNamed: theme.getBackgroundImageFile())
            bgNode.size = self.frame.size
            bgNode.anchorPoint = CGPoint(x: 0,y: 0)
            bgNode.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
            bgNode.zPosition = zPositionBackground
            self.addChild(bgNode)
            
            self.addPauseButtons()
            
            for emitter in theme.customEmitters {
                var nextEmitter : SKEmitterNode = SKEmitterNode(fileNamed: emitter.emitterName)
                nextEmitter.position = CGPoint(x: emitter.getX(self), y: emitter.getY(self))
                nextEmitter.zPosition = zPositionTable
                gameplayNode.addChild(nextEmitter)
            }
            applyLighting(self)
            startGame()
        }
    }
    
    // this function is called at the initialization of the game. It allows the paddles to start moving and starts the timer
    public func startGame() {
        
        var countdownSize = CGSize(width: self.frame.width * 0.7, height: self.frame.height * 0.7)
        startupNode = GameTimer(seconds: 3, font: theme.fontName!, size: countdownSize, singleSecond: true)
        startupNode.zPosition = zPositionStartTimer
        startupNode.position = CGPoint(x: self.frame.midX,y: self.frame.midY - startupNode.frame.height/2)
        startupNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        self.addChild(startupNode)
        startupNode.timer.start()
        
    

    }
    
    private func getScoreLabelNode() -> SKLabelNode {
        let score = SKLabelNode(fontNamed: theme.fontName)
        score.zPosition = zPositionTimer
        score.fontSize = timer.getFontSize()
        score.zRotation = CGFloat((M_PI*3.0)/2.0)
        score.text = "0"
        return score
    }
    
    public func handleGameConcluded() {
        
        pauseButton.inactivate()
        pauseButton.hidden=true
        
        var playerOneName="AI"
        var playerTwoName="AI"
        
        if !(userOne==nil) {
            playerOneName=userOne!.getUsername()!
        }
        if !(userTwo==nil) {
            playerTwoName=userTwo!.getUsername()!
        }
        let win = WinScreen(p1Score: playerOne.score, p2Score: playerTwo.score, p1Name: playerOneName, p2Name: playerTwoName, t: theme, parent: self)
        
        win.position = CGPoint(x: self.frame.minX, y: self.frame.minY)

        self.addChild(win)
        self.touchHandlers.append(win)
        gameOver = true
        if (playerOne is HumanPlayer) {
            let temp : HumanPlayer = (playerOne as! HumanPlayer)
            temp.handleGameConcluded(playerTwo.score, timePlayed: Int(timer.timer.getElapsedTimeSeconds()!))
        }
        if (playerTwo is HumanPlayer) {
            let temp : HumanPlayer = (playerTwo as! HumanPlayer)
            temp.handleGameConcluded(playerOne.score, timePlayed: Int(timer.timer.getElapsedTimeSeconds()!))
        }
    }
    
    
    public func pauseGame() {
    
        overlayNode.hidden = false
        self.getTimer()!.timer.pause()
        self.physicsWorld.speed=0.0
        self.gamePaused=true
        activeNode = overlayNode
        pauseButton.inactivate()
        resumeButton.activate()
        exitButton.activate()
        if (!self.isGameStarted()) {
            startupNode.timer.pause()
        }
        if (powerup != nil && powerup!.timer != nil ) {
            powerup!.timer!.pause()
        }
    }
    
    public func resumeGame() {
        overlayNode.hidden = true
        self.getTimer()!.timer.unpause()
        self.physicsWorld.speed = defaultPhysicsSpeed
        self.gamePaused=false
        activeNode = gameplayNode
        pauseButton.activate()
        resumeButton.inactivate()
        exitButton.inactivate()
        if (!self.isGameStarted()) {
            startupNode.timer.unpause()
        }
        if (powerup != nil && powerup!.timer != nil ) {
            powerup!.timer!.unpause()
        }
    }
    
    public func exitGame() {
        //TODO: this needs to roll back to the previous screen
        if (playerOne is HumanPlayer) {
            let temp : HumanPlayer = (playerOne as! HumanPlayer)
            if (self.isGameStarted()) {
                temp.handleGameExited(playerTwo.score, timePlayed: Int(timer.timer.getElapsedTimeSeconds()!))

            } else {
                temp.handleGameExited(0, timePlayed: 0)

            }
        }
        if (playerTwo is HumanPlayer) {
            let temp : HumanPlayer = (playerTwo as! HumanPlayer)
            
            if (self.isGameStarted()) {
                temp.handleGameExited(playerOne.score, timePlayed: Int(timer.timer.getElapsedTimeSeconds()!))
                
            } else {
                temp.handleGameExited(0, timePlayed: 0)
                
            }
            
            
        }
        navigationController!.popViewControllerAnimated(true)
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
    
    
   
    
    
    
    override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        handleTouches(touches)
    }
    
   override public func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        handleTouches(touches)

    }
    
    override public func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        handleTouches(touches)

    }
    override public func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent!) {
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
    func getPaddleSprite(playerNumber : Int,radius: CGFloat, mass : CGFloat)-> Paddle{
        var paddle = Paddle(imageNamed: theme.boardName+"Paddle.png")
       
       
        paddle.configurePaddle(playerNumber,radius: radius, settingsProfile: settingsProfile, mass : mass)
        return paddle
    }
    
    
    override public func didEvaluateActions() {
        if (self.isGameRunning()) {
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
    
    private func getPlayerFromPlayerNumber(number : Int) -> Player {
        if number==1 {
            return playerOne
        }
        return playerTwo
    }
    
    //handles a goal being scored on the given player
    private func handleGoalScored(playerScoredOn : Int) {
        soundManager.playGoalSound()
        if (playerScoredOn==1) {
            playerTwo.score=playerTwo.score+1
            if (playerTwo.score == settingsProfile.getGoalLimit() && settingsProfile.getGoalLimit()>0) {
                self.handleGameConcluded()
                return
            }
        } else {
            playerOne.score=playerOne.score+1
            if (playerOne.score == settingsProfile.getGoalLimit() && settingsProfile.getGoalLimit()>0) {
                self.handleGameConcluded()
                return
            }
        }
        playingTable.resetPuckToPlayer(playerScoredOn)
        playerOneScore.text = String(playerOne.score)
        playerTwoScore.text = String(playerTwo.score)
        EffectManager.runFlashEffect(gameplayNode.childNodeWithName(TABLE_EFFECT_OVERLAY_NAME)! as! SKShapeNode,originalColor: SKColor.clearColor(), flashColor: SKColor.whiteColor())
        
    }
    
   
    
    //TODO: Refactor these tasks to somewhere else?
    override public func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        if (self.isGameRunning()) {
            
            
            // if the timer is hidden, that means there is no countdown
            if (timer.timer.getRemainingTimeSeconds()==0 && !timer.hidden) {
                timer.setFinished()
                self.handleGameConcluded()
                return
            }
            playerOne.getPaddle()!.lastPosition = playerOne.getPaddle()!.position
            playerTwo.getPaddle()!.lastPosition = playerTwo.getPaddle()!.position
            playerOne.movePaddle()
            playerTwo.movePaddle()
            let puck = self.playingTable.getPuck()
            var goalScored = false
            
            playingTable.enumerateChildNodesWithName(GOAL_NAME, usingBlock: {
                (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                let goal = node as! Goal
                if (Geometry.nodeContainsNode(goal, innerNode: self.playingTable.getPuck())) {
                    goal.handleGoalScored()
                    self.handleGoalScored(goal.getPlayerNumber())
                    
                }
            
            
            })
            
            if (powerup == nil) {
                
                let randomNumber = GameUtil.getRandomFloat()
                
                if (randomNumber  < powerupOdds) {
                    let testSize = CGSize(width: 50,height: 50)
                    powerup = Powerup.getRandomPowerup(testSize, del: SizeIncreasePowerup(s: self))
                    playingTable.addChild(powerup!)
                    powerup!.moveToRandomPositionOnBoard(playingTable)
                }
                
            } else {
                let powerupFinished = powerup!.update()
                if (powerupFinished) {
                    powerup = nil
                }
            }
        } else if (!self.isGameStarted()) {
            if (startupNode.timer.isDone()!) {
            
                self.timer.timer.start()
                self.gameStarted = true
                startupNode.hidden = true
                
                
                self.addChild(goNode)
                
                let x : SKAction = SKAction.sequence([SKAction.waitForDuration(0.4), SKAction.fadeOutWithDuration(0.4)])
                goNode.runAction(x)
                
                
                
            }
        }
        
        
    }
   override public func didSimulatePhysics() {
        super.didSimulatePhysics()
        playerOne.processPaddlePosition()
        playerTwo.processPaddlePosition()
        playingTable.getPuck().capSpeed(MAX_PUCK_SPEED)
    
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
    public func isGameConcluded() -> Bool {
        return gameOver
    }
    public func isGameStarted() -> Bool {
        return gameStarted
    }
    public func isGameRunning() -> Bool {
        return !isGamePaused() && !isGameConcluded() && isGameStarted()
    }
    
    public func applyLighting(node : SKNode) {
        bgNode.lightingBitMask = lightCategory
        playerOne.getPaddle()!.lightingBitMask = lightCategory
        playerTwo.getPaddle()!.lightingBitMask = lightCategory
        playingTable.lightingBitMask = lightCategory
        playingTable.getPuck().lightingBitMask = lightCategory
    }
}
