//
//  ZegoUserService.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/13.
//

import Foundation
import ZIM

protocol UserServiceDelegate : AnyObject  {
    func connectionStateChanged(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent)
    /// receive user join room
    func roomUserJoin(_ users: [UserInfo])
    /// reveive user leave room
    func roomUserLeave(_ users: [UserInfo])
    /// receive custom command: invitation
    func receiveTakeSeatInvitation()
}

extension UserServiceDelegate {
    func roomUserJoin(_ users: [UserInfo]) { }
    func roomUserLeave(_ users: [UserInfo]) { }
    func receiveTakeSeatInvitation() { }
}

class UserService: NSObject {
    // MARK: - Public
    private let delegates = NSHashTable<AnyObject>.weakObjects()
    var localInfo: UserInfo?
    var userList = DictionaryArrary<String, UserInfo>()
    var coHostList: [CoHostSeatModel] = []
    
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
    
    /// user login with user info and `ZIM token`
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
                self.localInfo = user
                result = .success(())
            } else {
                result = .failure(.other(Int32(error.code.rawValue)))
            }
            guard let callback = callback else { return }
            callback(result)
        })
    }
    
    /// user logout
    func logout() {
        ZIMManager.shared.zim?.logout()
        RoomManager.shared.logoutRtcRoom(true)
    }
        
    /// get the number of chat rooms available online
    func getOnlineRoomUsersNum(callback: OnlineRoomUsersCountCallback?) {
        guard let roomID = RoomManager.shared.roomService.info.roomID else {
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
    
    /// get users of target page.
    func getOnlineRoomUsers(_ page: UInt, callback: OnlineRoomUsersCallback?) {
        guard let roomID = RoomManager.shared.roomService.info.roomID else {
            assert(false, "room ID can't be nil")
            guard let callback = callback else { return }
            callback(.failure(.failed))
            return
        }
        let config = ZIMQueryMemberConfig()
        config.count = 100
        config.nextFlag = String(page)
        ZIMManager.shared.zim?.queryRoomMember(roomID, config: config, callback: { zimUsers, nextFlag, error in
            
            if error.code != .ZIMErrorCodeSuccess {
                guard let callback = callback else { return }
                callback(.failure(.other(Int32(error.code.rawValue))))
                return
            }
            var users: [UserInfo] = []
            
            for zimUser in zimUsers {
                let role: UserRole = zimUser.userID == RoomManager.shared.roomService.info.hostID ? .host : .participant
                let user = UserInfo(zimUser.userID, zimUser.userName, role)
                users.append(user)
            }
            guard let callback = callback else { return }
            callback(.success(users))
        })
    }
    
    /// send an invitation message to add co-host
    func addCoHost(_ userID: String, callback: RoomCallback?) {
        
    }
    
    /// respond to the co-host invitation
    func respondCoHostInvitation(_ accept: Bool, callback: RoomCallback?) {
        
    }
    
    /// request to co-host
    func requestToCoHost(callback: RoomCallback?) {
        
    }
    
    func cancelRequestToCoHost(callback: RoomCallback?) {
        
    }
    
    /// respond to the co-host request
    func respondCoHostRequest(_ agree: Bool, callback: RoomCallback?) {
        
    }
    
    /// prohibit turning on the mic
    func muteUser(_ userID: String, callback: RoomCallback?) {
        
    }
    
    /// mic operation
    func micOperation(_ open: Bool) {
        
    }
    
    /// camera operation
    func cameraOpen(_ open: Bool) {
        
    }
    
    /// leave co-host seat
    func leaveCoHostSeat(callback: RoomCallback?) {
        
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
            let role: UserRole = zimUser.userID == RoomManager.shared.roomService.info.hostID ? .host : .participant
            let user = UserInfo(zimUser.userID, zimUser.userName, role)
            addUsers.append(user)
            guard let userID = user.userID else { continue }
            userList.addObj(userID, user)
            if localInfo?.userID == userID {
                localInfo = user
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
            let role: UserRole = zimUser.userID == RoomManager.shared.roomService.info.hostID ? .host : .participant
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
    }
    
    // recevie a invitation via this method
    func zim(_ zim: ZIM, receivePeerMessage messageList: [ZIMMessage], fromUserID: String) {
        for message in messageList {
            guard let message = message as? ZIMCustomMessage else { continue }
            guard let jsonStr = String(data: message.message, encoding: .utf8) else { continue }
            let command: InvitationCommand = InvitationCommand(with: jsonStr)
            if command.targetUserID?.count == 0 { continue }
            
            for delegate in delegates.allObjects {
                guard let delegate = delegate as? UserServiceDelegate else { continue }
                delegate.receiveTakeSeatInvitation()
            }
        }
    }
}
