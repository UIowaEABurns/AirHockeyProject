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
    
    public class func playBackgroundMusic(fileName : String) {
        let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        if (bgPlayer != nil && bgPlayer!.playing) {
            bgPlayer!.stop()

        }
       
        bgPlayer = AVAudioPlayer(contentsOfURL: music, error: nil)
        bgPlayer!.volume = Float(BG_MUSIC_VOLUME)
        bgPlayer!.prepareToPlay()
        bgPlayer!.numberOfLoops = -1
        bgPlayer!.play()
    }
    
    //the relative speed is how fast the puck and wall are going relative to each other.
    public class func playWallClick(relativeSpeed : CGFloat) {
        if (wallClickPlayer != nil) {
            wallClickPlayer!.play()
        }
    }
    public class func playGoalSound() {
        if (goalPlayer != nil) {
            goalPlayer!.play()
        }
    }
    public class func playPaddleClick(relativeSpeed : CGFloat) {
        if (paddleClickPlayer != nil) {
            paddleClickPlayer!.play()
        }
        
    }
    
    // given a theme, loads the clicking and goal sounds so that they can be played quickly during the game.
    public class func loadSounds(t : Theme){
        let wallClick = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(t.getPuckWallSoundName(), ofType: "mp3")!)
        wallClickPlayer = AVAudioPlayer(contentsOfURL: wallClick, error: nil)
        wallClickPlayer!.volume = Float(FX_VOLUME)
        wallClickPlayer!.prepareToPlay()
        
        let paddleClick = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(t.getPuckPaddleSoundName(), ofType: "mp3")!)
        paddleClickPlayer = AVAudioPlayer(contentsOfURL: paddleClick, error: nil)
        paddleClickPlayer!.volume = Float(FX_VOLUME)
        paddleClickPlayer!.prepareToPlay()
        
        let goal = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(t.getGoalSound(), ofType: "mp3")!)
        goalPlayer = AVAudioPlayer(contentsOfURL: goal, error: nil)
        goalPlayer!.volume = Float(FX_VOLUME)
        goalPlayer!.prepareToPlay()
    }
    
}