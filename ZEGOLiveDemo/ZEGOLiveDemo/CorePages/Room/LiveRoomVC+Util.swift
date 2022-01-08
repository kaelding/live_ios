//
//  LiveRoomVC+Util.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/7.
//

import Foundation

extension LiveRoomVC {
    
    // get user with user ID
    func getUser(_ userID: String?) -> UserInfo? {
        guard let userID = userID else {
            return nil
        }
        
        for user:UserInfo in RoomManager.shared.userService.userList.allObjects() {
            if user.userID == userID {
                return user
            }
        }
        return nil
    }
    
    func getHostID() -> String {
        return RoomManager.shared.roomService.roomInfo.hostID ?? ""
    }
    
    func getRoomID() -> String {
        return RoomManager.shared.roomService.roomInfo.roomID ?? ""
    }
    
    func getBottomUIType() -> LiveBottomUIType {
        let role = RoomManager.shared.userService.localUserInfo?.role
        switch role {
        case .host: return .host
        case .coHost: return .coHost
        case .participant: return .participant
        default: return .participant
        }
    }
    
    // get local user ID
    var localUserID: String {
        get {
            return RoomManager.shared.userService.localUserInfo?.userID ?? ""
        }
    }
    
    var isMyselfHost: Bool {
        RoomManager.shared.roomService.roomInfo.hostID == localUserID
    }
}
