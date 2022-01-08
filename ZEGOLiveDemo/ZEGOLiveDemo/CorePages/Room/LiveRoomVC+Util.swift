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
    
    // if the user on the co-host seat
    func isUserOnSeat(_ userID: String?) -> Bool {
        guard let userID = userID else {
            return false
        }

        for seat in RoomManager.shared.userService.coHostList {
            if seat.userID == userID { return true }
        }
        return false
    }
    
    // if the user in the request co-host list.
    func isUserInRequestList(_ userID: String?) -> Bool {
        guard let userID = userID else {
            return false
        }
        for coHostID in RoomManager.shared.userService.requestCoHostList {
            if coHostID == userID { return true }
        }
        return false
    }
    
    // is myself on the co-host seat
    var isMyselfOnSeat: Bool {
        isUserOnSeat(localUserID)
    }
    
    // is myself in the request cohost list
    var isMyselfInRequestList: Bool {
        isUserInRequestList(localUserID)
    }
    
    
    // get local user ID
    var localUserID: String {
        RoomManager.shared.userService.localUserInfo?.userID ?? ""
    }
    
    var isMyselfHost: Bool {
        RoomManager.shared.userService.isMyselfHost
    }
}
