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
            let alert = UIAlertController(title: ZGLocalizedString("room_page_destroy_room"),
                                          message: ZGLocalizedString("dialog_sure_to_destroy_room"),
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_cancel"), style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_ok"), style: .default) { action in
                self.leaveRoom()
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
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
