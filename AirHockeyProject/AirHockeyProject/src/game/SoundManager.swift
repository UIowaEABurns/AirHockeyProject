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
public class SoundManager {
    
    private class func playSound(p: AVAudioPlayer?) {
        if p==nil {
            return
        }
        if (!muted) {
            let player = p!
            if (player.playing) {
                player.stop()
                player.currentTime = 0.0
            }
            
            player.play()
        }
    }
    
    private class func playMusic(p: AVAudioPlayer?) {
        if (p==nil) {
            return
        }
        let player = p!
        player.numberOfLoops = -1
        player.volume = Float(BG_MUSIC_VOLUME)
        playSound(player)
    }
    
    private class func playSoundEffect(player : AVAudioPlayer?) {
        player!.volume = Float(FX_VOLUME)
        playSound(player)
    }
    
    //the relative speed is how fast the puck and wall are going relative to each other.
    public class func playWallClick(relativeSpeed : CGFloat) {
        playSoundEffect(wallClickPlayer)
    }
    public class func playGoalSound() {
        playSoundEffect(goalPlayer)
    }
    public class func playPaddleClick(relativeSpeed : CGFloat) {
        playSoundEffect(paddleClickPlayer)
        
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
    public class func loadSounds(t : Theme){
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        
        let wallClick = getSoundURL(t.getPuckWallSoundName(), type: "mp3")
        if (wallClick != nil) {
            wallClickPlayer = AVAudioPlayer(contentsOfURL: wallClick, error: nil)
            wallClickPlayer!.volume = Float(FX_VOLUME)
            wallClickPlayer!.prepareToPlay()
        }
        
        
        let paddleClick = getSoundURL(t.getPuckPaddleSoundName(), type: "mp3")
        if (paddleClick != nil) {
            paddleClickPlayer = AVAudioPlayer(contentsOfURL: paddleClick, error: nil)
            paddleClickPlayer!.volume = Float(FX_VOLUME)
            paddleClickPlayer!.prepareToPlay()
        }
        
        
        let goal = getSoundURL(t.getGoalSound(), type: "mp3")
        if (goal != nil) {
            goalPlayer = AVAudioPlayer(contentsOfURL: goal, error: nil)
            goalPlayer!.volume = Float(FX_VOLUME)
            goalPlayer!.prepareToPlay()
        }
        
        
        
        let music = getSoundURL(t.getBackgroundMusicName(), type: "mp3")
        if (music != nil ) {
            bgPlayer = AVAudioPlayer(contentsOfURL: music, error: nil)
            bgPlayer!.prepareToPlay()
            playMusic(bgPlayer)
        }
        

    }
    // perform when mute is selected
    public func mute() {
        if (bgPlayer != nil) {
            bgPlayer!.volume = 0.0

        }
    }
    
    public func unmute() {
        if (bgPlayer != nil) {
            bgPlayer!.volume = Float(BG_MUSIC_VOLUME)
            
        }
    }
    
    
    
}