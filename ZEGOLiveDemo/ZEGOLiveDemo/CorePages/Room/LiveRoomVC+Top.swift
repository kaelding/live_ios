//
//  LiveRoomVC+Top.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation
import UIKit

extension LiveRoomVC : LiveTopViewDelegate {
    func liveTopView(_ topView: LiveTopView, didClickButtonWith action: LiveTopAction) {
        print("liveTopView did click button: \(action)")
        switch action {
        case .participant:
            participantListView.isHidden = false
        case .close:
            leaveRoom()
        }
    }
    
    func leaveRoom() {
        // cancel request to cohost and leave co host when leave room.
        if isMyselfInRequestList {
            RoomManager.shared.userService.cancelRequestToCoHost(callback: nil)
        }
        if isMyselfOnSeat {
            RoomManager.shared.userService.leaveCoHostSeat(callback: nil)
        }
        
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else { return }
        RoomManager.shared.roomListService.leaveServerRoom(roomID, callback: nil)
        RoomManager.shared.roomService.leaveRoom(callback: nil)
        self.navigationController?.popViewController(animated: true)
        RoomManager.shared.deviceService.resert()
        RoomManager.shared.soundService.resert()
    }
        
    func updateTopView() {
        let host = getHost()
        let number = RoomManager.shared.userService.userList.count
        self.topView?.updateUI(userName: host?.userName, num: String(number))
    }
}
