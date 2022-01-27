//
//  ZegoRoomService.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/13.
//

import Foundation
import ZIM

/// The delegate related to room status callbacks
///
/// Description: Callbacks that be triggered when room status changes.
protocol RoomServiceDelegate: AnyObject {
    /// Callback for the room status update
    ///
    /// Description: This callback will be triggered when the text chat is disabled or there is a speaker seat be closed in the room. And all uses in the room receive a notification through this callback.
    ///
    /// @param roomInfo refers to the updated room information.
    func receiveRoomInfoUpdate(_ info: RoomInfo?)
}


/// Class ZEGOLive information management
///
/// Description: This class contains the room information management logic, such as the logic of create a room, join a room, leave a room, disable the text chat in room, etc.
class RoomService: NSObject {
    
    // MARK: - Private
    override init() {
        super.init()
        
        // RoomManager didn't finish init at this time.
        DispatchQueue.main.async {
            RoomManager.shared.addZIMEventHandler(self)
        }
    }
    
    // MARK: - Public
    /// Room information, it will be assigned after join the room successfully. And it will be updated synchronously when the room status updates.
    var roomInfo: RoomInfo = RoomInfo()
    /// The delegate related to the room status
    weak var delegate: RoomServiceDelegate?
    
    var operation: OperationCommand = OperationCommand()
    
    
    /// Create a room
    ///
    /// Description: This method can be used to create a room. The room creator will be the Host by default when the room is created successfully.
    ///
    /// Call this method at: After user logs in
    ///
    /// @param roomID refers to the room ID, the unique identifier of the room. This is required to join a room and cannot be null.
    /// @param roomName refers to the room name. This is used for display in the room and cannot be null.
    /// @param token refers to the authentication token. To get this, see the documentation: https://docs.zegocloud.com/article/11648
    /// @param callback refers to the callback for create a room.
    func createRoom(_ roomID: String, _ roomName: String, _ token: String, callback: RoomCallback?) {
        guard roomID.count != 0 else {
            guard let callback = callback else { return }
            callback(.failure(.paramInvalid))
            return
        }
        RoomManager.shared.resetRoomData()
        let parameters = getCreateRoomParameters(roomID, roomName)
        ZIMManager.shared.zim?.createRoom(parameters.0, config: parameters.1, callback: { fullRoomInfo, error in
            
            var result: ZegoResult = .success(())
            if error.code == .ZIMErrorCodeSuccess {
                RoomManager.shared.roomService.roomInfo = parameters.2
                RoomManager.shared.userService.localUserInfo?.role = .host
                RoomManager.shared.loginRtcRoom(with: token)
            }
            else {
                if error.code == .ZIMErrorCodeCreateExistRoom {
                    result = .failure(.roomExisted)
                } else {
                    result = .failure(.other(Int32(error.code.rawValue)))
                }
            }
            
            guard let callback = callback else { return }
            callback(result)
        })
        
    }
    
    /// Join a room
    ///
    /// Description: This method can be used to join a room, the room must be an existing room.
    ///
    /// Call this method at: After user logs in
    ///
    /// @param roomID refers to the ID of the room you want to join, and cannot be null.
    /// @param token refers to the authentication token. To get this, see the documentation: https://docs.zegocloud.com/article/11648
    /// @param callback refers to the callback for join a room.
    func joinRoom(_ roomID: String, _ token: String, callback: RoomCallback?) {
        RoomManager.shared.resetRoomData()
        ZIMManager.shared.zim?.joinRoom(roomID, callback: { fullRoomInfo, error in
            if error.code != .ZIMErrorCodeSuccess {
                guard let callback = callback else { return }
                if error.code == .ZIMErrorCodeRoomNotExist {
                    callback(.failure(.roomNotFound))
                } else {
                    callback(.failure(.other(Int32(error.code.rawValue))))
                }
                return
            }
            RoomManager.shared.roomService.roomInfo.roomID = fullRoomInfo.baseInfo.roomID
            RoomManager.shared.loginRtcRoom(with: token)
            RoomManager.shared.roomService.getRoomStatus { result in
                guard let callback = callback else { return }
                switch result {
                case .success():
                    callback(.success(()))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        })
    }
    
    /// Leave the room
    ///
    /// Description: This method can be used to leave the room you joined. The room will be ended when the Host leaves, and all users in the room will be forced to leave the room.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param callback refers to the callback for leave a room.
    func leaveRoom(callback: RoomCallback?) {

        let roomID = self.roomInfo.roomID
        let role = RoomManager.shared.userService.localUserInfo?.role
        
        // if call the leave room api, just logout rtc room
        RoomManager.shared.logoutRtcRoom()
        
        guard let roomID = roomID else {
            assert(false, "room ID can't be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        if role == .host {
            RoomManager.shared.roomListService.endServerRoom(roomID, callback: nil)
        } else {
            RoomManager.shared.roomListService.leaveServerRoom(roomID, callback: nil)
        }
        ZIMManager.shared.zim?.leaveRoom(roomID, callback: { error in
            var result: ZegoResult = .success(())
            if error.code != .ZIMErrorCodeSuccess {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
    
    func getRoomStatus(callback: RoomCallback?) {
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else {
            assert(false, "room ID can't be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        ZIMManager.shared.zim?.queryRoomAllAttributes(byRoomID: roomID, callback: { roomAttributes, error in
            var result: ZegoResult = .success(())
            if error.code == .ZIMErrorCodeSuccess {
                self.roomAttributesUpdated(roomAttributes)
            } else {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
}

// MARK: - Private
extension RoomService {
    
    private func getCreateRoomParameters(_ roomID: String, _ roomName: String) -> (ZIMRoomInfo, ZIMRoomAdvancedConfig, RoomInfo) {
        
        let zimRoomInfo = ZIMRoomInfo()
        zimRoomInfo.roomID = roomID
        zimRoomInfo.roomName = roomName
        
        let roomInfo = RoomInfo()
        roomInfo.hostID = RoomManager.shared.userService.localUserInfo?.userID
        roomInfo.roomID = roomID
        roomInfo.roomName = roomName.count > 0 ? roomName : roomID
        
        let config = ZIMRoomAdvancedConfig()
        let roomInfoJson = ZegoJsonTool.modelToJson(toString: roomInfo) ?? ""
        
        config.roomAttributes = ["room_info" : roomInfoJson]
        
        return (zimRoomInfo, config, roomInfo)
    }
}

extension RoomService: ZIMEventHandler {
    
    func zim(_ zim: ZIM, connectionStateChanged state: ZIMConnectionState, event: ZIMConnectionEvent, extendedData: [AnyHashable : Any]) {
        
    }
    
    func zim(_ zim: ZIM, roomStateChanged state: ZIMRoomState, event: ZIMRoomEvent, extendedData: [AnyHashable : Any], roomID: String) {
        
        // if host reconneted
        if state == .connected && event == .success {
            let newInRoom = roomInfo.hostID == nil
            if newInRoom { return }
            // when reconnected must send a heart beat request.
            RoomManager.shared.roomListService.heartBeatRequest()
            ZIMManager.shared.zim?.queryRoomAllAttributes(byRoomID: roomID, callback: { dict, error in
                let hostLeft = error.code == .ZIMErrorCodeSuccess && !dict.keys.contains("room_info")
                let roomNotExisted = error.code == .ZIMErrorCodeRoomNotExist
                if hostLeft || roomNotExisted {
                    self.delegate?.receiveRoomInfoUpdate(nil)
                }
                if error.code == .ZIMErrorCodeSuccess {
                    self.roomAttributesUpdated(dict)
                }
            })
        } else if state == .disconnected {
//            delegate?.receiveRoomInfoUpdate(nil)
        }
    }
    
    func zim(_ zim: ZIM, roomAttributesUpdated updateInfo: ZIMRoomAttributesUpdateInfo, roomID: String) {
        roomAttributesUpdated(updateInfo.roomAttributes)
    }
}
