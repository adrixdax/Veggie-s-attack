//
//  SKTAudio.swift
//  VeggiesAttack
//
//  Created by Alessio Gazzara on 11/12/22.
//

import AVFoundation

private let SKTAudioInstance = SKTAudio()


class SKTAudio{
    
    var bgMusic: AVAudioPlayer?
    var shootEffect: AVAudioPlayer?
    static func sharedInstance() -> SKTAudio {
        return SKTAudioInstance
    }
    func playMusic(_ fileNamed : String){
        if !SKTAudio.musicEnabled { return }
        guard let url = Bundle.main.url(forResource: fileNamed, withExtension: nil) else { return }
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
        }   catch let error as NSError {
            bgMusic = nil
        }
        if let bgMusic = bgMusic {
            bgMusic.numberOfLoops = 1
            bgMusic.prepareToPlay()
            bgMusic.play()
        }
    }
    
    
    func stopBGMusic(){
        if let bgMusic = bgMusic{
            if bgMusic.isPlaying{
                bgMusic.stop()
            }
        }
    }
    
    func pauseBGMusic(){
        if let bgMusic = bgMusic{
            if bgMusic.isPlaying{
                bgMusic.pause()
            }
        }
    }
    
    func resumeBGMusic(){
        if let bgMusic = bgMusic{
            if !bgMusic.isPlaying{
                bgMusic.play()
            }
        }
    }
    
    func playSFX(_ fileNamed : String){
        guard let url = Bundle.main.url(forResource: fileNamed, withExtension: nil) else { return }
        do {
            shootEffect = try AVAudioPlayer(contentsOf: url)
            
        }   catch _ as NSError {
            shootEffect = nil
        }
        if let shootEffect = shootEffect {
            shootEffect.numberOfLoops = 0
            shootEffect.prepareToPlay()
            shootEffect.play()
        }
    }
    static let keyMusic = "keyMusic"
    static var musicEnabled: Bool = {
        return !UserDefaults.standard.bool(forKey:  keyMusic)
    }() {
        didSet{
            let value = !musicEnabled
             UserDefaults.standard.set(value, forKey:  keyMusic)
            if value {
                SKTAudio.sharedInstance().stopBGMusic()
            } else
                
            {
                SKTAudio.sharedInstance().resumeBGMusic()
            }
        }
    }
}
