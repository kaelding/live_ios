//
//  SoundEffectService.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/4.
//

import UIKit
import ZegoExpressEngine

class SoundEffectService: NSObject {
    
    var currentBgmPath: String = ""
    var BGMVolume: Int32 = 50
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
    
    func startBGM() {
        if player?.currentState != .playing {
            player?.start()
        }
    }
    
    func stopBGM() -> Void {
        if player?.currentState == .playing {
            player?.stop()
        }
    }
    
    func setBGMVolume(_ volume: Int) {
        BGMVolume = Int32(volume)
        player?.setVolume(Int32(volume))
    }
    
    func setVoiceVolume(_ volume: Int) {
        voiceVolume = Int32(volume)
        ZegoExpressEngine.shared().setCaptureVolume(Int32(volume) * 2)
    }
    
    func setVoiceChangeType(_ type: ZegoVoiceChangerPreset) {
        ZegoExpressEngine.shared().setVoiceChangerPreset(type)
    }
    
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
