//
//  DeviceService.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/6.
//

import UIKit
import ZegoExpressEngine

/// Class video resolution
///
/// Description: This class contains the video resolution information. To set the video resolution, call the setVideoResolution method.
enum ZegoVideoResolution: Int {
    /// 1080P: 1920 * 1080
    case p1080
    
    /// 720P: 1280 * 720
    case p720
    
    /// 540P: 960 * 540
    case p540
    
    /// 360P: 640 * 360
    case p360
    
    /// 270P: 480 * 270
    case p270
    
    /// 180P: 320 * 180
    case p180
}


/// Class audio bitrate
///
/// Description: This class contains the audio bitrate information. To set the audio bitrate, call the setAudioBitrate method.
enum ZegoAudioBitrate: Int {
    /// 16kbps
    case b16
    
    /// 48kbps
    case b48
    
    /// 56kbps
    case b56
    
    /// 96kbps
    case b96
    
    /// 128kbps
    case b128
    
    /// 192kbps
    case b192
}


/// Class video format
///
/// Description: This class contains the video coding formats information. To set video format, call the setVideoCodec method.
enum ZegoVideoCode: Int {
    /// H264 video format
    case h264
    
    /// H265 video format
    case h265
}


/// Class device settings
///
/// Description: This class contains the device settings related information for you to configure different device settings.
enum ZegoDevicesType {
    /// Codec
    case encoding
    
    /// Layered coding
    case layeredCoding
    
    /// Hardware encoding
    case hardwareEncoder
    
    /// Hardware decoding
    case hardwareDecoder
    
    /// Noise suppression
    case noiseSuppression
    
    /// Echo cancellation
    case echoCancellation
    
    /// Volume auto-adjustment
    case volumeAdjustment
    
    /// Video resolution
    case videoResolution
    
    /// Audio bitrate
    case bitrate
}


/// Class device management
///
/// Description: This class contains the device settings related logic for you to configure different device settings.
class DeviceService: NSObject {

    /// Video resolution
    var videoResolution: ZegoVideoResolution = .p720
    
    /// Audio bitrate
    var bitrate: ZegoAudioBitrate = .b48
    
    /// Video codec
    var codec: ZegoVideoCode = .h264
    
    /// Whether to enable or disable the layered coding
    var layeredCoding: Bool = false
    
    /// Whether to enable or disable the hardware coding
    var hardwareCoding: Bool = true
    
    /// Whether to enable or disable the hardware decoding
    var hardwareDecoding: Bool = false
    
    /// Whether to enable or disable the noise suppression
    var noiseSliming: Bool = false
    
    /// Whether to enable or disable the echo cancellation
    var echoCancellation: Bool = false
    
    /// Whether to enable or disable the volume auto-adjustment
    var volumeAdjustment: Bool = false
    
    override init() {
        super.init()
        setNomalConfigValue()
    }
    
    
    /// Set video resolution
    ///
    /// Description: This method can be used to set video resolution. A larger resolution consumes more network bandwidth. You can select the resolution based on service requirements and network conditions. The default value is 720P.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param resolution refers to the resolution value.
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
    
    
    /// Set audio bitrate
    ///
    /// Description: This method can be used to set audio bitrate.  A larger audio bitrate consumes more network bandwidth. You can select the bitrate based on service requirements and network conditions. The default value is 48kbps.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param bitrate refers to the bitrate value.
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
    
    
    /// Set video codec
    ///
    /// Description: Different devices support different coding formats. Some devices do not support H.265. We recommend you to use the H.264.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param codec refers to the codec type.
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
    
    
    /// Configure device settings
    ///
    /// Description: This method can be used to configure device settings as actual business requirements.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param type refers to the configuration type.
    /// @param enable determines whether to enable or disable.
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
    
    
    /// Camera related operations
    ///
    /// Description: This method can be enable or disable the camera. The video streams will be automatically published to remote users when the camera is on.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param enable determines whether to enable or disable the camera. true: Enable false: Disable
    func enableCamera(_ enable: Bool) {
        ZegoExpressEngine.shared().enableCamera(enable)
    }
    
    
    /// Microphone related operations
    ///
    /// Description: This method can be used to mute or unmute the microphone. The audio streams will be automatically published to remote users when the microphone is on.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param mute determines whether to mute or unmute the microphone. true: Mute false: Unmute
    func muteMic(_ mute: Bool) {
        ZegoExpressEngine.shared().muteMicrophone(mute)
    }
    
    
    /// Use front-facing and rear camera
    ///
    /// Description: This method can be used to set the camera, the SDK uses the front-facing camera by default.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param isFront determines whether to use the front-facing camera or the rear camera.  true: Use front-facing camera. false: Use rear camera.
    func useFrontCamera(_ isFront: Bool) {
        ZegoExpressEngine.shared().useFrontCamera(isFront)
    }
    
    
    /// Playback video streams data
    ///
    /// Description: This can be used to intuitively play the video stream data, the audio stream data is played by default.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param userID refers to the ID of the user you want to play the video streams from.
    /// @param view refers to the target view that you want to be rendered.
    func playVideoStream(_ userID: String, view: UIView) {
        let canvas = ZegoCanvas(view: view)
        canvas.viewMode = .aspectFill
        if RoomManager.shared.userService.localUserInfo?.userID == userID {
            ZegoExpressEngine.shared().startPreview(canvas)
        } else {
            guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else { return }
            let streamID = String.getStreamID(userID, roomID: roomID)
            ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: canvas)
        }
    }
    
    func stopPlayStream(_ userID: String) {
        if RoomManager.shared.userService.localUserInfo?.userID == userID {
            ZegoExpressEngine.shared().stopPreview()
        } else {
            guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else { return }
            let streamID = String.getStreamID(userID, roomID: roomID)
            ZegoExpressEngine.shared().stopPlayingStream(streamID)
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
