//
//  SoundManager.swift
//  AirHockeyProject
//
//  Created by divms on 4/9/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import AVFoundation
private var bgPlayer : AVAudioPlayer? = nil
private var wallClickPlayer : AVAudioPlayer? = nil
private var paddleClickPlayer : AVAudioPlayer? = nil
private var goalPlayer : AVAudioPlayer? = nil

private var buttonPlayer : AVAudioPlayer? = nil

private var powerupPlayer : AVAudioPlayer? = nil
private var countdownPlayer : AVAudioPlayer? = nil
private var goPlayer : AVAudioPlayer? = nil



private var soundManagerDelegate = SoundManager()
public class SoundManager : NSObject, AVAudioPlayerDelegate {
    var isMuted = false // whether THIS INSTANCE is muted
    private func playSound(p: AVAudioPlayer?) {
        if p==nil {
            return
        }
        if (!muted && !isMuted) {
            dispatch_async(dispatch_get_main_queue()) {
                let player = p!
                if (player.playing) {
                    //player.stop()
                    //player.currentTime = 0.0
                } else {
                    player.play()

                }
                
            }
            
            
            
        }
    }
    
    private func playMusic(p: AVAudioPlayer?) {
        if (p==nil) {
            return
        }
        let player = p!
        player.numberOfLoops = -1
        p!.volume = BG_MUSIC_VOLUME
        playSound(player)
    }
    
    private func playSoundEffect(player : AVAudioPlayer?) {
        if (player == nil) {
            return
        }
        player!.volume = FX_VOLUME
        playSound(player)
    }
    
    //the relative speed is how fast the puck and wall are going relative to each other.
    public  func playWallClick(relativeSpeed : CGFloat) {
        playSoundEffect(wallClickPlayer)
    }
    public  func playGoalSound() {
        playSoundEffect(goalPlayer)
    }
    public func playPaddleClick(relativeSpeed : CGFloat) {
        playSoundEffect(paddleClickPlayer)
        
    }
    
    public func playButtonPressedSound() {
        playSoundEffect(buttonPlayer)
    }
    
    public func playCountdownSound() {
        playSoundEffect(countdownPlayer)
    }
    public func playGoSound() {
        playSoundEffect(goPlayer)
    }
    public func playPowerupSound() {
        playSoundEffect(powerupPlayer)
    }
    
    private class func getSoundURL(fileName : String, type : String) -> NSURL? {
        let url = NSBundle.mainBundle().pathForResource(fileName, ofType: type)
        if (url==nil) {
            return nil
        }
        return NSURL(fileURLWithPath: url!)
    }
    
    
    
    
    
    // given a theme, loads the clicking and goal sounds so that they can be played quickly during the game.
    // also starts playing the background music
    public func loadSounds(t : Theme){
        if (isMuted) {
            return
        }
        
        
        
        let wallClick = SoundManager.getSoundURL(t.getPuckWallSoundName(), type: "mp3")
        if (wallClick != nil) {
            wallClickPlayer = AVAudioPlayer(contentsOfURL: wallClick, error: nil)
            wallClickPlayer!.delegate = soundManagerDelegate
            wallClickPlayer!.prepareToPlay()
        }
        
        
        let paddleClick = SoundManager.getSoundURL(t.getPuckPaddleSoundName(), type: "mp3")
        if (paddleClick != nil) {
            paddleClickPlayer = AVAudioPlayer(contentsOfURL: paddleClick, error: nil)
            paddleClickPlayer!.delegate = soundManagerDelegate
            paddleClickPlayer!.prepareToPlay()
        }
        
        
        let goal = SoundManager.getSoundURL(t.getGoalSound(), type: "mp3")
        if (goal != nil) {
            goalPlayer = AVAudioPlayer(contentsOfURL: goal, error: nil)
            goalPlayer!.delegate = soundManagerDelegate
            goalPlayer!.prepareToPlay()
        }
        
        
        
        let music = SoundManager.getSoundURL(t.getBackgroundMusicName(), type: "mp3")
        if (music != nil ) {
            bgPlayer = AVAudioPlayer(contentsOfURL: music, error: nil)
            bgPlayer!.prepareToPlay()
            playMusic(bgPlayer)
        }
        

    }
    // perform when mute is selected
    public class func mute() {
        if (bgPlayer != nil) {
            bgPlayer!.stop()

        }
    }
    
    public class func unmute() {
        SoundManager().playMusic(bgPlayer)
    }
    
    public class func volumeChanged() {
        if (bgPlayer != nil) {
            bgPlayer!.volume = BG_MUSIC_VOLUME
            
        }
    }
    
    public class func playMenuMusic() {
        let music = SoundManager.getSoundURL("menuBackgroundMusic", type: "mp3")
        if (music != nil ) {
            bgPlayer = AVAudioPlayer(contentsOfURL: music, error: nil)
            bgPlayer!.prepareToPlay()
            SoundManager().playMusic(bgPlayer)
        }
    }
    
    //this is executed on startup to load some basic system sounds, and it also starts the bgPlayer
    public class func setupSystemSounds() {
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        let menuSound =  SoundManager.getSoundURL("menuSelect", type: ".mp3")
        if (menuSound != nil) {
            buttonPlayer = AVAudioPlayer(contentsOfURL: menuSound, error: nil)
            buttonPlayer!.delegate = soundManagerDelegate
            buttonPlayer!.prepareToPlay()
        }
        
        playMenuMusic()
        
        let powerupSound = SoundManager.getSoundURL("Powerup",type: "wav")
        if (powerupSound != nil) {
            powerupPlayer = AVAudioPlayer(contentsOfURL: powerupSound, error: nil)
            powerupPlayer!.delegate = soundManagerDelegate
            powerupPlayer!.prepareToPlay()
        }
        
        let countdownSound = SoundManager.getSoundURL("Countdown",type: "wav")
        if (countdownSound != nil) {
            countdownPlayer = AVAudioPlayer(contentsOfURL: countdownSound, error: nil)
            countdownPlayer!.delegate = soundManagerDelegate
            countdownPlayer!.prepareToPlay()
        }
        
        let goSound = SoundManager.getSoundURL("GoSound",type: "wav")
        if (goSound != nil) {
            goPlayer = AVAudioPlayer(contentsOfURL: goSound, error: nil)
            goPlayer!.delegate = soundManagerDelegate
            goPlayer!.prepareToPlay()
        }
    }
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        player.prepareToPlay()
    }
    
    
}