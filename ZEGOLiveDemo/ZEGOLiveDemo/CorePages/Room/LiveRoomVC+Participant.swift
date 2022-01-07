//
//  LiveRoomVC+Participant.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2022/1/7.
//

import Foundation
import ZIM

extension LiveRoomVC {
    
}

extension LiveRoomVC : UserServiceDelegate {
    func connectionStateChanged(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent) {
        
    }
    

    func roomUserJoin(_ users: [UserInfo]) {
        
        var tempList: [MessageModel] = []
        for user in users {
            if user.userID == localUserID {
                tempList.removeAll()
                break
            }
            let model: MessageModel = MessageModelBuilder.buildJoinMessageModel(user: user)
            tempList.append(model)
        }
        messageList.append(contentsOf: tempList)
        
        reloadMessageData()
        participantListView.reloadListView()
        updateTopView()
    }
    
    func roomUserLeave(_ users: [UserInfo]) {
        
        for user in users {
            if user.userID == localUserID { continue }
            let model: MessageModel = MessageModelBuilder.buildLeftMessageModel(user: user)
            messageList.append(model)
        }
        
        reloadMessageData()
        participantListView.reloadListView()
        updateTopView()
    }
    
    func receiveAddCoHostInvitation() {
        
    }
    /// receive add co-host invitation respond
    func receiveAddCoHostRespond(_ accept: Bool) {
        
    }
    /// receive request to co-host request
    func receiveToCoHostRequest() {
        
    }
    /// receive cancel request to co-host
    func receiveCancelToCoHostRequest() {
        
    }
    /// receive response to request to co-host
    func receiveToCoHostRespond(_ agree: Bool) {
        
    }
    
    func coHostChange(_ coHost: CoHostSeatModel?, type: CoHostChangeType) {
        
    }
}
