//
//  DeviceService.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/6.
//

import UIKit
import ZegoExpressEngine


enum ZegoVideoResolution: Int {
    case p1080
    case p720
    case p540
    case p360
    case p270
    case p180
}

enum ZegoAudioBitrate: Int {
    case b16
    case b48
    case b56
    case b96
    case b128
    case b192
}

enum ZegoVideoCode: Int {
    case h264
    case h265
}

enum ZegoDevicesType {
    case encoding
    case layeredCoding
    case hardwareEncoder
    case hardwareDecoder
    case noiseSuppression
    case echoCancellation
    case volumeAdjustment
    case videoResolution
    case bitrate
}

class DeviceService: NSObject {

    var videoResolution: ZegoVideoResolution = .p720
    var bitrate: ZegoAudioBitrate = .b48
    var codec: ZegoVideoCode = .h264
    var layeredCoding: Bool = false
    var hardwareCoding: Bool = true
    var hardwareDecoding: Bool = false
    var noiseSliming: Bool = false
    var echoCancellation: Bool = false
    var volumeAdjustment: Bool = false
    
    override init() {
        super.init()
        setNomalConfigValue()
    }
    
    
    func setVideoResolution(_ resolution: ZegoVideoResolution) {
        videoResolution = resolution
        var expressVideoPreset: ZegoVideoConfigPreset = .preset720P
        switch resolution {
        case .p1080:
            expressVideoPreset = .preset1080P
        case .p720:
            expressVideoPreset = .preset720P
        case .p540:
            expressVideoPreset = .preset540P
        case .p360:
            expressVideoPreset = .preset360P
        case .p270:
            expressVideoPreset = .preset270P
        case .p180:
            expressVideoPreset = .preset180P
        }
        let videoConfig: ZegoVideoConfig = ZegoVideoConfig.init(preset: expressVideoPreset)
        switch codec {
        case .h264:
            if layeredCoding {
                videoConfig.codecID = .IDSVC
            } else {
                videoConfig.codecID = .idDefault
            }
        case .h265:
            videoConfig.codecID = .IDH265
        }
        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
    }
    
    func setAudioBitrate(_ bitrate: ZegoAudioBitrate) {
        self.bitrate = bitrate
        let audioConfig: ZegoAudioConfig = ZegoAudioConfig()
        audioConfig.bitrate = 48
        switch bitrate {
        case .b16: audioConfig.bitrate = 16
        case .b48: audioConfig.bitrate = 48
        case .b56: audioConfig.bitrate = 56
        case .b96: audioConfig.bitrate = 96
        case .b128: audioConfig.bitrate = 128
        case .b192: audioConfig.bitrate = 192
        }
        ZegoExpressEngine.shared().setAudioConfig(audioConfig)
    }
    
    func setVideoCodec(_ codec: ZegoVideoCode) {
        self.codec = codec
        switch codec {
        case .h264:
            setDeviceStatus(.hardwareEncoder, enable: true)
        case .h265:
            setDeviceStatus(.layeredCoding, enable: false)
            setDeviceStatus(.hardwareEncoder, enable: true)
        }
    }
    
    func setDeviceStatus(_ type: ZegoDevicesType, enable: Bool) {
        switch type {
        case .encoding, .videoResolution, .bitrate:
            return
        case .layeredCoding:
            layeredCoding = enable
            setVideoResolution(videoResolution)
        case .hardwareEncoder:
            ZegoExpressEngine.shared().enableHardwareEncoder(enable)
            hardwareCoding = enable
        case .hardwareDecoder:
            ZegoExpressEngine.shared().enableHardwareDecoder(enable)
            hardwareDecoding = enable
        case .noiseSuppression:
            noiseSliming = enable
            ZegoExpressEngine.shared().enableANS(enable)
            ZegoExpressEngine.shared().enableTransientANS(enable)
        case .echoCancellation:
            echoCancellation = enable
            ZegoExpressEngine.shared().enableAEC(enable)
        case .volumeAdjustment:
            volumeAdjustment = enable
            ZegoExpressEngine.shared().enableAGC(enable)
        }
    }
    
    func enableCamera(_ enable: Bool) {
        ZegoExpressEngine.shared().enableCamera(enable)
    }
    
    func muteMic(_ mute: Bool) {
        ZegoExpressEngine.shared().muteMicrophone(mute)
    }
    
    func useFrontCamera(_ isFront: Bool) {
        ZegoExpressEngine.shared().useFrontCamera(isFront)
    }
    
    func playVideoStream(_ userID: String, view: UIView) {
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else { return }
        let streamID = String.getStreamID(userID, roomID: roomID)
        let canvas = ZegoCanvas(view: view)
        canvas.viewMode = .aspectFill
        if RoomManager.shared.userService.localUserInfo?.userID == userID {
            ZegoExpressEngine.shared().startPreview(canvas)
        } else {
            ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: canvas)
        }
    }
    
    func isVideoEncoderSupportedH265() -> Bool {
        ZegoExpressEngine.shared().enableHardwareEncoder(true)
        return ZegoExpressEngine.shared().isVideoEncoderSupported(.IDH265)
    }
    
    func setNomalConfigValue() {
        setVideoCodec(codec)
        setVideoResolution(videoResolution)
        setAudioBitrate(bitrate)
        setDeviceStatus(.layeredCoding, enable: layeredCoding)
        setDeviceStatus(.hardwareEncoder, enable: hardwareCoding)
        setDeviceStatus(.hardwareDecoder, enable: hardwareDecoding)
        setDeviceStatus(.noiseSuppression, enable: noiseSliming)
        setDeviceStatus(.echoCancellation, enable: echoCancellation)
        setDeviceStatus(.volumeAdjustment, enable: volumeAdjustment)
    }
    
    func reset() {
        videoResolution = .p720
        bitrate = .b48
        codec = .h264
        layeredCoding = false
        hardwareCoding = true
        hardwareDecoding = false
        noiseSliming = false
        echoCancellation = false
        volumeAdjustment = false
        setNomalConfigValue()
    }
    
}
