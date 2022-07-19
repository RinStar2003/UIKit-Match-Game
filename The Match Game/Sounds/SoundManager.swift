//
//  SoundManager.swift
//  The Match Game
//
//  Created by мас on 09.07.2022.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case match
        case nomatch
        case shuffle
        
    }
    
    func playSound(effect: SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            case .flip:
                soundFileName = "cardflip"
            case .match:
                soundFileName = "dingcorrect"
            case .nomatch:
                soundFileName = "dingwrong"
            case .shuffle:
                soundFileName = "shuffle"
            
        }
        
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        // Check that it's not nil
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
     
        do {
            
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Play this sound effect
            audioPlayer?.play()
            
        } catch {
            
            print("Error", error)
            return
        }
        
    }
}
