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
        if action == .close {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
