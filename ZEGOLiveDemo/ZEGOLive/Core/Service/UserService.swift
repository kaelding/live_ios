//
//  ZegoUserService.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/13.
//

import Foundation
import ZIM
import ZegoExpressEngine

enum CoHostChangeType {
    case take
    case leave
    case remove
    case mic
    case camera
    case mute
}

/// The delegate related to the user status callbacks
///
/// Description: Callbacks that be triggered when in-room user status change.
protocol UserServiceDelegate : AnyObject  {
    
    /// Callbacks related to the user connection status
    ///
    /// Description: This callback will be triggered when user gets disconnected due to network error, or gets offline due to the operations in other clients.
    ///
    /// @param state refers to the current connection state.
    /// @param event refers to the the event that causes the connection status changes.
    func connectionStateChanged(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent)
    
    /// Callback for new user joins the room
    ///
    /// Description: This callback will be triggered when a new user joins the room, and all users in the room will receive a notification. The in-room user list data will be updated automatically.
    ///
    /// @param userList refers to the latest new-comer user list. Existing users are not included.
    func roomUserJoin(_ users: [UserInfo])
    
    /// Callback for existing user leaves the room
    ///
    /// Description: This callback will be triggered when an existing user leaves the room, and all users in the room will receive a notification. The in-room user list data will be updated automatically.
    ///
    /// @param userList refers to the list of users who left the room.
    func roomUserLeave(_ users: [UserInfo])
    
    /// Callback for receive a co-host invitation
    ///
    /// Description: This callback will be triggered when a participant in the room was invited to co-host by the host.
    func receiveAddCoHostInvitation()
    
    /// Callback for receive the response of a co-host invitation
    ///
    /// Description: This callback will be triggered when the host receives the participant's response of the co-host invitation.
    ///
    /// @param accept indicates whether the invited participant accept or decline the invitation.
    func receiveAddCoHostRespond(_ userInfo: UserInfo, accept: Bool)
    
    /// Callback for receive a co-host request
    ///
    /// Description: This callback will be triggered when the host receive a co-host request sent by a participant in the room.
    func receiveToCoHostRequest(_ userInfo: UserInfo)
    
    /// Callback for a co-host request has been canceled
    ///
    /// Description: This callback will be triggered and the host will receive a notification through this callback when a participant cancel his co-host request.
    func receiveCancelToCoHostRequest(_ userInfo: UserInfo)
    
    /// Callback for receive the response of a co-host request
    ///
    /// Description: This callback will be triggered and the participant who requested to co-host will receive a notification through this callback when the host responds to the co-host request.
    ///
    /// @param agree determines whether to accept or decline the co-host request.
    func receiveToCoHostRespond(_ agree: Bool)
    
    /// Callback for co-host status changes
    ///
    /// Description: This callback will be triggered and all participants will receive a notification through this callback when the status of a co-host changes.
    ///
    /// @param targetUserID refers to the ID of the participant whose status has changed.
    /// @param type refers to the change type.
    func coHostChange(_ targetUserID: String, type: CoHostChangeType)
}

// default realized
extension UserServiceDelegate {
    func roomUserJoin(_ users: [UserInfo]) { }
    func roomUserLeave(_ users: [UserInfo]) { }
    func receiveAddCoHostInvitation() { }
    func receiveAddCoHostRespond(_ userInfo: UserInfo, accept: Bool) { }
    func receiveToCoHostRequest(_ userInfo: UserInfo) { }
    func receiveCancelToCoHostRequest(_ userInfo: UserInfo) { }
    func receiveToCoHostRespond(_ agree: Bool) { }
    func coHostChange(_ targetUserID: String, type: CoHostChangeType) { }
}


/// Class user information management
///
/// Description: This class contains the user information management logic, such as the logic of log in, log out, get the logged-in user info, get the in-room user list, and add co-hosts, etc.
class UserService: NSObject {
    // MARK: - Public
    /// The delegate related to user status
    let delegates = NSHashTable<AnyObject>.weakObjects()
    
    /// The local logged-in user information.
    var localUserInfo: UserInfo?
    
    /// In-room user list, can be used when displaying the user list in the room.
    var userList = DictionaryArray<String, UserInfo>()
    
    /// Co-host list, can be used when display the co-host list in the room.
    var coHostList: [CoHostModel] {
        RoomManager.shared.roomService.operation.coHost
    }
    
    var requestCoHostList: [String] {
        RoomManager.shared.roomService.operation.requestCoHost
    }
    
    override init() {
        super.init()
        
        // RoomManager didn't finish init at this time.
        DispatchQueue.main.async {
            RoomManager.shared.addZIMEventHandler(self)
        }
    }
    
    func addUserServiceDelegate(_ delegate: UserServiceDelegate) {
        self.delegates.add(delegate)
    }
    
    /// User to log in
    ///
    /// Description: Call this method with user ID and username to log in to the ZEGO Live service.
    ///
    /// Call this method at: After the SDK initialization
    ///
    /// @param userInfo refers to the user information. You only need to enter the user ID and username.
    /// @param token refers to the authentication token. To get this, refer to the documentation: https://docs.zegocloud.com/article/11648
    /// @param callback refers to the callback for log in.
    func login(_ user: UserInfo, _ token: String, callback: RoomCallback?) {
        
        guard let userID = user.userID else {
            guard let callback = callback else { return }
            callback(.failure(.paramInvalid))
            return
        }
        
        guard let userName = user.userName else {
            guard let callback = callback else { return }
            callback(.failure(.paramInvalid))
            return
        }
        
        let zimUser = ZIMUserInfo()
        zimUser.userID = userID
        zimUser.userName = userName
        
        ZIMManager.shared.zim?.login(zimUser, token: token, callback: { error in
            var result: ZegoResult
            if error.code == .ZIMErrorCodeSuccess {
                self.localUserInfo = user
                result = .success(())
            } else {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
    
    /// User to log out
    ///
    /// Description: This method can be used to log out from the current user account.
    ///
    /// Call this method at: After the user login
    func logout() {
        ZIMManager.shared.zim?.logout()
        RoomManager.shared.logoutRtcRoom(true)
    }
        
    /// Get the total number of in-room users
    ///
    /// Description: This method can be called to get the total number of the in-room users.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param callback refers to the callback for get the total number of in-room users.
    func getOnlineRoomUsersNum(callback: OnlineRoomUsersNumCallback?) {
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else {
            assert(false, "room ID can't be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        
        ZIMManager.shared.zim?.queryRoomOnlineMemberCount(roomID, callback: { count, error in
            var result: Result<UInt32, ZegoError>
            if error.code == .ZIMErrorCodeSuccess {
                result = .success(count)
            } else {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
    
    /// Get the in-room user list
    ///
    /// Description: This method can be called to get the in-room user list.
    ///
    /// Call this method at:  After joining the room
    ///
    /// @param nextFlag: Passing a null value to nextFlag will get the 100 people who recently joined the room. Passing in the nextFlag value returned from the last query retrieves the list of users since the last query.
    /// @param callback refers to the callback for get the in-room user list.
    func getOnlineRoomUsers(_ nextFlag: String?, callback: OnlineRoomUserListCallback?) {
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else {
            assert(false, "room ID can't be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        let config = ZIMQueryMemberConfig()
        config.count = 100
        config.nextFlag = nextFlag ?? ""
        ZIMManager.shared.zim?.queryRoomMember(roomID, config: config, callback: { zimUsers, nextFlag, error in
            
            if error.code != .ZIMErrorCodeSuccess {
                guard let callback = callback else { return }
                callback(.failure(.other(Int32(error.code.rawValue))))
                return
            }
            var users: [UserInfo] = []
            
            for zimUser in zimUsers {
                let role: UserRole = zimUser.userID == RoomManager.shared.roomService.roomInfo.hostID ? .host : .participant
                let user = UserInfo(zimUser.userID, zimUser.userName, role)
                users.append(user)
            }
            guard let callback = callback else { return }
            let ret = UserListResult(users: users, nextFlag: nextFlag)
            callback(.success(ret))
        })
    }
    
    /// Make co-hosts
    ///
    /// Description: This method can be called to invite an existing participant to co-host, the invited participant will receive a invitation.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param userID refers to the ID of the user that you want to invite to be a co-host.
    ///
    /// @param callback refers to the callback for make a co-host.
    func addCoHost(_ userID: String, callback: RoomCallback?) {
        let invitation = CustomCommand(.invitation)
        invitation.targetUserIDs.append(userID)
        guard let json = invitation.json(),
              let data = json.data(using: .utf8) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        
        let customMessage: ZIMCustomMessage = ZIMCustomMessage(message: data)
        ZIMManager.shared.zim?.sendPeerMessage(customMessage, toUserID: userID, callback: { _, error in
            var result: ZegoResult
            if error.code == .ZIMErrorCodeSuccess {
                result = .success(())
                if let user = self.userList.getObj(userID) {
                    user.hasInvited = true
                }
            } else {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
    
    /// Respond to the co-host invitation
    ///
    /// Description: This method can be used to accept or decline the co-host invitation sent by the host.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param accept: Pass true or false to accept or decline the invitation.
    ///
    /// @param callback refers to the callback for respond to the co-host invitation.
    func respondCoHostInvitation(_ accept: Bool, callback: RoomCallback?) {
        guard let userID = RoomManager.shared.userService.localUserInfo?.userID else { return }
        guard let hostID = RoomManager.shared.roomService.roomInfo.hostID else {
            assert(false, "the room ID can't be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        
        let respond = CustomCommand(.respondInvitation)
        respond.targetUserIDs.append(userID)
        respond.content = CustomCommandContent(accept: accept)
        
        guard let json = respond.json(),
              let data = json.data(using: .utf8) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        
        let customMessage: ZIMCustomMessage = ZIMCustomMessage(message: data)
        ZIMManager.shared.zim?.sendPeerMessage(customMessage, toUserID: hostID, callback: { _, error in
            var result: ZegoResult
            if error.code == .ZIMErrorCodeSuccess {
                result = .success(())
            } else {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
    
    /// Request to co-host
    ///
    /// Description: This method can be used to send a co-host request to the host.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param callback refers to the callback for request to co-host.
    func requestToCoHost(callback: RoomCallback?) {
        guard let parameters = getRequestOrCancelToHostParameters(localUserInfo?.userID, isRequest: true) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        setRoomAttributes(parameters.0, parameters.1, parameters.2, callback)
    }
    
    /// Cancel the co-host request
    ///
    /// Description: This method can be used when a participant wants to cancel the co-host request.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param callback refers to the callback for cancel the co-host request.
    func cancelRequestToCoHost(callback: RoomCallback?) {
        cancelRequestToCoHost(localUserInfo?.userID, callback: callback)
    }
    
    // private method, host can use this method to cancel request
    private func cancelRequestToCoHost(_ userID: String?, callback: RoomCallback?) {
        guard let parameters = getRequestOrCancelToHostParameters(userID, isRequest: false) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        setRoomAttributes(parameters.0, parameters.1, parameters.2, callback)
    }
    
    /// Respond to the co-host request
    ///
    /// Description: This method can be called when the host responds to the co-host request sent by participants. The participants can call the takeSeat to be a co-host when the co-host request has been accept.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param callback refers to the callback for respond to the co-host request.
    func respondCoHostRequest(_ agree: Bool, _ userID: String, callback: RoomCallback?) {
        // remove user ID from coHost
        guard let parameters = getRespondCoHostParameters(agree, userID: userID) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        setRoomAttributes(parameters.0, parameters.1, parameters.2, callback)
    }
    
    /// Take a co-host seat
    ///
    /// Description: This method can be used to take a co-host seat. All participants in the room receive a notification when this gets called. And the number of co-hosts changes, the streams of the participant who just take the seat will be played.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param callback refers to the callback for take a co-host seat.
    func takeSeat(callback: RoomCallback?) {
        
        if coHostList.compactMap({ $0.userID }).contains(localUserInfo?.userID) {
            guard let callback = callback else { return }
            callback(.failure(.alreadyOnSeat))
            return
        }
        
        guard let parameters = getTakeOrLeaveSeatParameters(localUserInfo?.userID, isTake: true) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        // publish stream
        guard let myUserID = localUserInfo?.userID else { return }
        let streamID = String.getStreamID(myUserID, roomID: parameters.1)
        
        setRoomAttributes(parameters.0, parameters.1, parameters.2) { result in
            if result.isSuccess {
                ZegoExpressEngine.shared().startPublishingStream(streamID)
                ZegoExpressEngine.shared().enableCamera(true)
                ZegoExpressEngine.shared().muteMicrophone(false)
            }
            guard let callback = callback else { return }
            callback(result)
        }
    }
    
    
    /// Leave a co-host seat
    ///
    /// Description: This method can be used to leave the current seat. All participants in the room receive a notification when this gets called, and the UI shows a notification, the streams of the participant who just left the seat will not be played.
    ///
    /// Call this method at: After joining a room
    ///
    /// @param callback refers to the callback for leave a co-host seat.
    func leaveSeat(callback: RoomCallback?) {
        removeUserFromSeat(localUserInfo?.userID, callback: callback)
    }
    
    func removeUserFromSeat(_ userID: String?, callback: RoomCallback?) {
        guard let parameters = getTakeOrLeaveSeatParameters(userID, isTake: false) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        setRoomAttributes(parameters.0, parameters.1, parameters.2, callback)
    }
        
    /// Mute co-hosts
    ///
    /// Description: This method can be used to mute or unmute a co-host. Once a co-host is muted by the host, he can only speak again until the host's next unmute operation.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param isMute determines whether to mute or unmute a co-host.  true: mute. false: unmute.
    /// @param userID refers to the ID of the co-host that the host want to mute.
    /// @param callback refers to the callback for mute a co-host.
    func muteUser(_ isMuted: Bool, userID: String, callback: RoomCallback?) {
        guard let hostID = RoomManager.shared.roomService.roomInfo.hostID,
              let myUserID = localUserInfo?.userID
        else {
            assert(false, "the hostID or roomID cannot be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        
        // only the host have access to call this method
        if hostID != myUserID {
            guard let callback = callback else { return }
            callback(.failure(.noPermission))
            return
        }
        
        guard let parameters = getSeatChangeParameters(userID ,enable: isMuted, flag: 2) else {
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        
        setRoomAttributes(parameters.0, parameters.1, parameters.2, callback)
    }
    
    /// Microphone related operations
    ///
    /// Description: This method can be used to turn on/off the microphone. The audio streams will be published to remote users when the microphone is on, and the audio stream publishing stops when the microphone is off. This method will failed to be called when you have been muted.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param open determines whether to turn on or turn off the microphone. true: turn on. false: turn off.
    /// @param callback refers to the callback for turn on or turn off the microphone.
    func micOperation(_ open: Bool) {
        
        guard let parameters = getSeatChangeParameters(localUserInfo?.userID, enable: open, flag: 0) else {
            return
        }
        
        // modify the mic before request
        guard let seatModel = RoomManager.shared.roomService.operation.coHost.filter({ $0.userID == localUserInfo?.userID }).first else {
            return
        }
        seatModel.mic = open
        requestSeq += 1
        setRoomAttributes(parameters.0, parameters.1, parameters.2) { result in
            if result.isSuccess {
                // open mic
                RoomManager.shared.deviceService.muteMic(!open)
            } else {
                seatModel.mic = !open
                requestSeq -= 1
            }
        }
    }
    
    /// Camera related operations
    ///
    /// Description: This method can be used to turn on/off the camera. The video streams will be published to remote users, and the video stream publishing stops when the camera is turned off.
    ///
    /// Call this method at:  After joining a room
    ///
    /// @param open determines whether to turn on or turn off the camera. true: turn on. false: turn off.
    /// @param callback refers to the callback for turn on or turn off the camera.
    func cameraOperation(_ open: Bool) {
        
        guard let parameters = getSeatChangeParameters(localUserInfo?.userID, enable: open, flag: 1) else {
            return
        }
        
        // modify the mic before request
        guard let seatModel = RoomManager.shared.roomService.operation.coHost.filter({ $0.userID == localUserInfo?.userID }).first else {
            return
        }
        seatModel.camera = open
        requestSeq += 1
        setRoomAttributes(parameters.0, parameters.1, parameters.2) { result in
            if result.isSuccess {
                // open camera
                RoomManager.shared.deviceService.enableCamera(open)
            } else {
                seatModel.camera = !open
                requestSeq -= 1
            }
        }
    }
}

// MARK: - Private
extension UserService {
    private func setRoomAttributes(_ attributes: [String : String],
                                   _ roomID: String,
                                   _ config: ZIMRoomAttributesSetConfig, _ callback: RoomCallback?) {
        ZIMManager.shared.zim?.setRoomAttributes(attributes, roomID: roomID, config: config, callback: { error in
            guard let callback = callback else { return }
            if error.code == .ZIMErrorCodeSuccess {
                callback(.success(()))
            } else {
                callback(.failure(.other(Int32(error.code.rawValue))))
            }
        })
    }
}

extension UserService : ZIMEventHandler {
    func zim(_ zim: ZIM, connectionStateChanged state: ZIMConnectionState, event: ZIMConnectionEvent, extendedData: [AnyHashable : Any]) {
        for obj  in delegates.allObjects {
            let delegate = obj as? UserServiceDelegate
            guard let delegate = delegate else { continue }
            delegate.connectionStateChanged(state, event)
        }
    }
    
    func zim(_ zim: ZIM, roomMemberJoined memberList: [ZIMUserInfo], roomID: String) {
        var addUsers: [UserInfo] = []
        for zimUser in memberList {
            let role: UserRole = zimUser.userID == RoomManager.shared.roomService.roomInfo.hostID ? .host : .participant
            var user = UserInfo(zimUser.userID, zimUser.userName, role)
            guard let userID = user.userID else { continue }
            // if user in the user list
            if !userList.contains(userID) {
                userList.addObj(userID, user)
            } else {
                user = userList.getObj(userID)!
            }
            if user.role != .host && coHostList.compactMap({ $0.userID}).contains(userID) {
                user.role = .coHost
            }
            addUsers.append(user)
            if localUserInfo?.userID == userID {
                localUserInfo = user
            }
        }
        
        for obj in delegates.allObjects {
            if let delegate = obj as? UserServiceDelegate {
                delegate.roomUserJoin(addUsers)
            }
        }
    }
    
    func zim(_ zim: ZIM, roomMemberLeft memberList: [ZIMUserInfo], roomID: String) {
        var leftUsers: [UserInfo] = []
        for zimUser in memberList {
            let role: UserRole = zimUser.userID == RoomManager.shared.roomService.roomInfo.hostID ? .host : .participant
            let user = UserInfo(zimUser.userID, zimUser.userName, role)
            leftUsers.append(user)
            guard let userID = user.userID else { continue }
            userList.removeObj(userID)
        }
        
        for obj in delegates.allObjects {
            if let delegate = obj as? UserServiceDelegate {
                delegate.roomUserLeave(leftUsers)
            }
        }
        
        // if the host receive user leave callback,
        // the host must remove the user from seat list and request list.
        if !isMyselfHost { return }
        for leftUser in leftUsers {
            if isUserInRequestList(leftUser.userID) {
                cancelRequestToCoHost(leftUser.userID, callback: nil)
            }
            if isUserOnSeat(leftUser.userID) {
                removeUserFromSeat(leftUser.userID, callback: nil)
            }
        }
    }
    
    // recevie a invitation via this method
    func zim(_ zim: ZIM, receivePeerMessage messageList: [ZIMMessage], fromUserID: String) {
        for message in messageList {
            guard let message = message as? ZIMCustomMessage else { continue }
            guard let jsonStr = String(data: message.message, encoding: .utf8) else { continue }
            let command: CustomCommand? = ZegoJsonTool.jsonToModel(type: CustomCommand.self, json: jsonStr)
            guard let command = command else { continue }
            if command.targetUserIDs.count == 0 { continue }
            
            
            for delegate in delegates.allObjects {
                guard let delegate = delegate as? UserServiceDelegate else { continue }
                if command.type == .invitation {
                    delegate.receiveAddCoHostInvitation()
                } else {
                    guard let accept = command.content?.accept else { continue }
                    if let user = self.userList.getObj(fromUserID) {
                        delegate.receiveAddCoHostRespond(user, accept: accept)
                    }
                }
            }
        }
    }
}
