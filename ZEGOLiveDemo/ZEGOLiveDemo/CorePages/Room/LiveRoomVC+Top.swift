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
        guard let roomID = RoomManager.shared.roomService.roomInfo.roomID else { return }
        RoomManager.shared.roomListService.leaveServerRoom(roomID, callback: nil)
        RoomManager.shared.roomService.leaveRoom(callback: nil)
        self.navigationController?.popViewController(animated: true)
    }
        
    func updateTopView() {
        let roomInfo = RoomManager.shared.roomService.roomInfo
//        guard let hostID = roomInfo.hostID else { return }
        guard let roomName = roomInfo.roomName else { return }
//        guard let hostInfo = RoomManager.shared.userService.userList.getObj(hostID) else { return }
//        topView?.avatarImageView.image = UIImage(named: hostInfo.)
        let number = RoomManager.shared.userService.userList.count
        topView?.nameLabel.text = roomName
        topView?.participantButton.setTitle(String(number), for: .normal)
    }
}
