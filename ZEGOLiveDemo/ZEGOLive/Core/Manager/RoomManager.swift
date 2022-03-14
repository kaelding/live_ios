//
//  ZegoRoomManager.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/13.
//

import Foundation
import ZIM
import ZegoExpressEngine
import ZegoEffects


/// Class ZEGO Live business logic management
///
/// Description: This class contains the ZEGO Live business logic, manages the service instances of different modules, and also distributing the data delivered by the SDK.
class RoomManager: NSObject {
    
    /// Get the ZegoRoomManager singleton instance
    ///
    /// Description: This method can be used to get the ZegoRoomManager singleton instance.
    ///
    /// Call this method at: Any time
    ///
    /// @return ZegoRoomManager singleton instance
    static let shared = RoomManager()
    
    // MARK: - Private
    private let rtcEventDelegates: NSHashTable<ZegoEventHandler> = NSHashTable(options: .weakMemory)
    private let zimEventDelegates: NSHashTable<ZIMEventHandler> = NSHashTable(options: .weakMemory)
    
    private override init() {
        roomService = RoomService()
        userService = UserService()
        messageService = MessageService()
        roomListService = RoomListService()
        beautifyService = FaceBeautifyService()
        soundService = SoundEffectService()
        deviceService = DeviceService()
        super.init()
    }
    
    // MARK: - Public
    
    /// The room information management instance, contains the room information, room status and other business logic.
    var roomService: RoomService
    /// The user information management instance, contains the in-room user information management, logged-in user information and other business logic.
    var userService: UserService
    /// The message management instance, contains the IM messages management logic.
    var messageService: MessageService
    /// The room management instance, contains the business logic of get room list, create a room, join a room, and more.
    var roomListService: RoomListService
    /// The face beautify management instance, contains the enabling/disabling logic and parameter setting logic of the face beautification and face shape retouch feature.
    var beautifyService: FaceBeautifyService
    /// The sound effects management instance, contains the sound effects business logic.
    var soundService: SoundEffectService
    /// The device management instance, contains the video capturing, rendering, related parameters, stream playing, and other bunsiness logic.
    var deviceService: DeviceService
    
    
    /// Initialize the SDK
    ///
    /// Description: This method can be used to initialize the ZIM SDK and the Express-audio SDK.
    ///
    /// Call this method at: Before you log in. We recommend you call this method when the application starts.
    ///
    /// @param appID refers to the project ID. To get this, go to ZEGOCLOUD Admin Console: https://console.zegocloud.com/
    /// @param appSign refers to the secret key for authentication. To get this, go to ZEGOCLOUD Admin Console: https://console.zegocloud.com
    func initWithAppID(appID: UInt32, callback: RoomCallback?) {
        ZIMManager.shared.createZIM(appID: appID)
        let profile = ZegoEngineProfile()
        profile.appID = appID
        profile.scenario = .general
        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
        
        EffectsLicense.shared.getLicense(appID, appSign: "cc96bc01d32549ec5f03218aa0a142056ce5206e715c3fdbf9e92dbf62e4d6c1")
                
        let processConfig = ZegoCustomVideoProcessConfig()
        processConfig.bufferType = .cvPixelBuffer
        ZegoExpressEngine.shared().enableCustomVideoProcessing(true, config: processConfig)
        ZegoExpressEngine.shared().setCustomVideoProcessHandler(self)
        
        var result: ZegoResult = .success(())
        if ZIMManager.shared.zim == nil {
            result = .failure(.other(1))
        } else {
            ZIMManager.shared.zim?.setEventHandler(self)
        }
        guard let callback = callback else { return }
        callback(result)
    }
    
    
    /// The method to deinitialize the SDK
    ///
    /// Description: This method can be used to deinitialize the SDK and release the resources it occupies.
    ///
    /// Call this method at: When the SDK is no longer be used. We recommend you call this method when the application exits.
    func uninit() {
        logoutRtcRoom(true)
        ZIMManager.shared.destoryZIM()
        ZegoExpressEngine.destroy(nil)
    }
    
    /// Upload local logs to the ZEGOCLOUD server
    ///
    /// Description: You can call this method to upload the local logs to the ZEGOCLOUD Server for troubleshooting when exception occurs.
    ///
    /// Call this method at: When exceptions occur.
    ///
    /// @param fileName refers to the name of the file you upload. We recommend you name the file in the format of "appid_platform_timestamp".
    /// @param completion refers to the callback that be triggered when the logs are upload successfully or failed to upload logs.
    func uploadLog(callback: RoomCallback?) {
        ZIMManager.shared.zim?.uploadLog({ errorCode in
            if errorCode.code == .ZIMErrorCodeSuccess {
                guard let callback = callback else { return }
                ZegoExpressEngine.shared().uploadLog { error in
                    if error == 0 {
                        callback(.success(()))
                    } else {
                        callback(.failure(.other(error)))
                    }
                }
            } else {
                guard let callback = callback else { return }
                callback(.failure(.other(Int32(errorCode.code.rawValue))))
            }
        })
    }
}

extension RoomManager {
    func loginRtcRoom(with rtcToken: String) {
        guard let userID = RoomManager.shared.userService.localUserInfo?.userID else {
            assert(false, "user id can't be nil.")
            return
        }
        
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else {
            assert(false, "room id can't be nil.")
            return
        }
        
        // login rtc room
        let user = ZegoUser(userID: userID)
        
        let config = ZegoRoomConfig()
        config.token = rtcToken
        config.maxMemberCount = 0
        ZegoExpressEngine.shared().loginRoom(roomID, user: user, config: config)
        
        // monitor sound level
        ZegoExpressEngine.shared().startSoundLevelMonitor(1000)
    }
        
    func logoutRtcRoom(_ containsUserService: Bool = false) {
        ZegoExpressEngine.shared().logoutRoom()
        resetRoomData()
    }
    
    func resetRoomData(_ containsUserService: Bool = false) {
        if containsUserService {
            userService = UserService()
            roomListService = RoomListService()
        }
        roomService = RoomService()
        messageService = MessageService()
        userService.userList = DictionaryArray<String, UserInfo>()
        userService.localUserInfo?.role = .participant
    }
    
    // MARK: - event handler
    func addZIMEventHandler(_ eventHandler: ZIMEventHandler?) {
        zimEventDelegates.add(eventHandler)
    }
    
    func addExpressEventHandler(_ eventHandler: ZegoEventHandler?) {
        rtcEventDelegates.add(eventHandler)
    }
}

extension RoomManager: ZegoEventHandler {
    
    func onCapturedSoundLevelUpdate(_ soundLevel: NSNumber) {
        for delegate in rtcEventDelegates.allObjects {
            delegate.onCapturedSoundLevelUpdate?(soundLevel)
        }
    }
    
    func onRemoteSoundLevelUpdate(_ soundLevels: [String : NSNumber]) {
        for delegate in rtcEventDelegates.allObjects {
            delegate.onRemoteSoundLevelUpdate?(soundLevels)
        }
    }
    
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        
        for stream in streamList {
            if updateType == .add {
//                ZegoExpressEngine.shared().startPlayingStream(stream.streamID, canvas: nil)
            } else {
                ZegoExpressEngine.shared().stopPlayingStream(stream.streamID)
            }
        }
        
        for delegate in rtcEventDelegates.allObjects {
            delegate.onRoomStreamUpdate?(updateType, streamList: streamList, extendedData: extendedData, roomID: roomID)
        }
    }
    
    func onPlayerStateUpdate(_ state: ZegoPlayerState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        for delegate in rtcEventDelegates.allObjects {
            delegate.onPlayerStateUpdate?(state, errorCode: errorCode, extendedData: extendedData, streamID: streamID)
        }
    }
    
    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        for delegate in rtcEventDelegates.allObjects {
            delegate.onPublisherStateUpdate?(state, errorCode: errorCode, extendedData: extendedData, streamID: streamID)
        }
    }
    
    func onNetworkQuality(_ userID: String, upstreamQuality: ZegoStreamQualityLevel, downstreamQuality: ZegoStreamQualityLevel) {
        for delegate in rtcEventDelegates.allObjects {
            delegate.onNetworkQuality?(userID, upstreamQuality: upstreamQuality, downstreamQuality: downstreamQuality)
        }
    }
}

extension RoomManager: ZIMEventHandler {
    func zim(_ zim: ZIM, connectionStateChanged state: ZIMConnectionState, event: ZIMConnectionEvent, extendedData: [AnyHashable : Any]) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, connectionStateChanged: state, event: event, extendedData: extendedData)
        }
    }
    
    // MARK: - Main
    func zim(_ zim: ZIM, errorInfo: ZIMError) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, errorInfo: errorInfo)
        }
    }
    
    func zim(_ zim: ZIM, tokenWillExpire second: UInt32) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, tokenWillExpire: second)
        }
    }
    
    // MARK: - Message
    func zim(_ zim: ZIM, receivePeerMessage messageList: [ZIMMessage], fromUserID: String) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, receivePeerMessage: messageList, fromUserID: fromUserID)
        }
    }
    
    func zim(_ zim: ZIM, receiveRoomMessage messageList: [ZIMMessage], fromRoomID: String) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, receiveRoomMessage: messageList, fromRoomID: fromRoomID)
        }
    }
    
    // MARK: - Room
    func zim(_ zim: ZIM, roomMemberJoined memberList: [ZIMUserInfo], roomID: String) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, roomMemberJoined: memberList, roomID: roomID)
        }
    }
    
    func zim(_ zim: ZIM, roomMemberLeft memberList: [ZIMUserInfo], roomID: String) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, roomMemberLeft: memberList, roomID: roomID)
        }
    }
    
    func zim(_ zim: ZIM, roomStateChanged state: ZIMRoomState, event: ZIMRoomEvent, extendedData: [AnyHashable : Any], roomID: String) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, roomStateChanged: state, event: event, extendedData: extendedData, roomID: roomID)
        }
    }
    
    func zim(_ zim: ZIM, roomAttributesUpdated updateInfo: ZIMRoomAttributesUpdateInfo, roomID: String) {
        for delegate in zimEventDelegates.allObjects {
            delegate.zim?(zim, roomAttributesUpdated: updateInfo, roomID: roomID)
        }
    }
}

extension RoomManager: ZegoCustomVideoProcessHandler {
    
    func onStart(_ channel: ZegoPublishChannel) {
        self.beautifyService.effects.initEnv(CGSize(width: 720, height: 1280))
    }
    
    
    func onCapturedUnprocessedCVPixelBuffer(_ buffer: CVPixelBuffer, timestamp: CMTime, channel: ZegoPublishChannel) {
        self.beautifyService.effects.processImageBuffer(buffer)
        ZegoExpressEngine.shared().sendCustomVideoProcessedCVPixelBuffer(buffer, timestamp: timestamp, channel: channel)
    }
}
