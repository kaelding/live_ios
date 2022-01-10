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
    
    func getHost() -> UserInfo? {
        return getUser(getHostID())
    }
        
    // if the user on the co-host seat
    func isUserOnSeat(_ userID: String?) -> Bool {
        return RoomManager.shared.userService.isUserOnSeat(userID)
    }
    
    // if the user in the request co-host list.
    func isUserInRequestList(_ userID: String?) -> Bool {
        return RoomManager.shared.userService.isUserInRequestList(userID)
    }
    
    func isUserMyself(_ userID: String?) -> Bool {
        return localUserID == userID
    }
    
    func getCoHost(_ userID: String?) -> CoHostModel? {
        guard let userID = userID else {
            return nil
        }
        for coHost in RoomManager.shared.userService.coHostList {
            if coHost.userID == userID { return coHost }
        }
        return nil
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
    
    var localCoHost: CoHostModel? {
        for coHost in RoomManager.shared.userService.coHostList {
            if coHost.userID == localUserID { return coHost }
        }
        return nil
    }
}
