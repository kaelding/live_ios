//
//  LiveRoomVC+Top.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation

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
        RoomManager.shared.roomService.leaveRoom { result in
            switch result {
            case .success():
                self.navigationController?.popViewController(animated: true)
                break
            case .failure(_):
                break
            }
        }
    }
}
