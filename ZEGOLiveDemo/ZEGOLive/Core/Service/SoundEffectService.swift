//
//  SoundEffectService.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/4.
//

import UIKit
import ZegoExpressEngine


/// Class sounc effects
///
/// Description: This class contains the sound effects logic.
class SoundEffectService: NSObject {
    
    var currentBgmPath: String = ""
    
    /// The volume of the background music. The default value is 50.
    var BGMVolume: Int32 = 50
    
    /// The volume of the voice. The default value is 50.
    var voiceVolume: Int32 = 50
    
    lazy var player: ZegoMediaPlayer? = {
        let mediaPlayer: ZegoMediaPlayer? = ZegoExpressEngine.shared().createMediaPlayer()
        guard let mediaPlayer = mediaPlayer else {
            return nil
        }
        mediaPlayer.enableAux(true)
        mediaPlayer.enableRepeat(true)
        return mediaPlayer
    }()
    
    private func destoryPlayer() {
        if let player = player {
            ZegoExpressEngine.shared().destroy(player)
        }
    }
        
    
    /// Load the background music file
    ///
    /// Description: This method can be used to load the background music by setting the file path and the music will be automatically played.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param path indicates the path of the music resource.
    func loadBGM(withFilePath path: String?) {
        func loadResoruce(_ path: String) {
            player?.loadResource(path, callback: { error in
                if error == 0 {
                    self.currentBgmPath = path
                    self.startBGM()
                }
            })
        }
        
        guard let path = path else {
            return
        }
        if player?.currentState == .playing {
            if currentBgmPath != path {
                stopBGM()
                loadResoruce(path)
            }
        } else {
            loadResoruce(path)
        }
    }
    
    
    /// Start playing the background music
    ///
    /// Description: This method can be used to restart the music that be stopped by calling the stopBGM method.
    ///
    /// Call this method at: After joining a room and calling the loadBGM method
    func startBGM() {
        if player?.currentState != .playing {
            player?.start()
        }
    }
    
    /// Stop the background music
    ///
    /// Description: This method can be used to stop playing the background music. And you can restart playing the music by calling the startBGM method.
    ///
    /// Call this method at: After joining a room and calling the loadBGM method
    func stopBGM() -> Void {
        if player?.currentState == .playing {
            player?.stop()
        }
    }
    
    /// Set the background music volume
    ///
    /// Description: The music volume range is [0, 100]. The default value is 50.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param volume refers to the music volume
    func setBGMVolume(_ volume: Int) {
        BGMVolume = Int32(volume)
        player?.setVolume(Int32(volume))
    }
    
    /// Set the voice volume
    ///
    /// Description: The voice volume range is [0, 100]. The default value is 50.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param volume refers to the voice volume
    func setVoiceVolume(_ volume: Int) {
        voiceVolume = Int32(volume)
        ZegoExpressEngine.shared().setCaptureVolume(Int32(volume) * 2)
    }
    
    /// Set voice changing
    ///
    /// Description: This method can be used to change the voice with voice effects.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param type refers to the voice type you want to changed to.
    func setVoiceChangeType(_ type: ZegoVoiceChangerPreset) {
        ZegoExpressEngine.shared().setVoiceChangerPreset(type)
    }
    
    /// Set reverb
    ///
    /// Description: This method can be used to use the reverb effect in the room.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param type refers to the reverb type you want to select.
    func setReverbPreset(_ type: ZegoReverbPreset) {
        ZegoExpressEngine.shared().setReverbPreset(type)
    }
    
    func reset() {
        currentBgmPath = ""
        BGMVolume = 50
        voiceVolume = 50
        setBGMVolume(Int(BGMVolume))
        setVoiceVolume(Int(voiceVolume))
        setVoiceChangeType(.none)
        setReverbPreset(.none)
        stopBGM()
    }

}
