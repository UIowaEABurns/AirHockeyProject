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

public class SoundManager {
    var isMuted = false // whether THIS INSTANCE is muted
    private func playSound(p: AVAudioPlayer?) {
        if p==nil {
            return
        }
        if (!muted && !isMuted) {
            let player = p!
            if (player.playing) {
                player.stop()
                player.currentTime = 0.0
            }
            
            player.play()
        }
    }
    
    private  func playMusic(p: AVAudioPlayer?) {
        if (p==nil) {
            return
        }
        let player = p!
        player.numberOfLoops = -1
        p!.volume = BG_MUSIC_VOLUME
        playSound(player)
    }
    
    private  func playSoundEffect(player : AVAudioPlayer?) {
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
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        
        let wallClick = SoundManager.getSoundURL(t.getPuckWallSoundName(), type: "mp3")
        if (wallClick != nil) {
            wallClickPlayer = AVAudioPlayer(contentsOfURL: wallClick, error: nil)
            wallClickPlayer!.prepareToPlay()
        }
        
        
        let paddleClick = SoundManager.getSoundURL(t.getPuckPaddleSoundName(), type: "mp3")
        if (paddleClick != nil) {
            paddleClickPlayer = AVAudioPlayer(contentsOfURL: paddleClick, error: nil)
            paddleClickPlayer!.prepareToPlay()
        }
        
        
        let goal = SoundManager.getSoundURL(t.getGoalSound(), type: "mp3")
        if (goal != nil) {
            goalPlayer = AVAudioPlayer(contentsOfURL: goal, error: nil)
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
    
    //this is executed on startup to load some basic system sounds, and it also starts the bgPlayer
    public class func setupSystemSounds() {
        let menuSound =  SoundManager.getSoundURL("menuSelect", type: ".mp3")
        if (menuSound != nil) {
            buttonPlayer = AVAudioPlayer(contentsOfURL: menuSound, error: nil)
            buttonPlayer?.prepareToPlay()
        }
        
        let music = SoundManager.getSoundURL("menuBackgroundMusic", type: "mp3")
        if (music != nil ) {
            bgPlayer = AVAudioPlayer(contentsOfURL: music, error: nil)
            bgPlayer!.prepareToPlay()
            println("playing bg music")
            SoundManager().playMusic(bgPlayer)
        }
    }
    
    
    
}