//
//  LiveRoomVC+Ready.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation

extension LiveRoomVC : LiveReadyViewDelegate {
    func liveReadyView(_ readyView: LiveReadyView, didClickButtonWith action: LiveReadyAction) {
        switch action {
        case .start:
            print("liveReadyView did click button: \(action)")
        case .beauty:
            self.beautifyContainer.isHidden = !self.beautifyContainer.isHidden
        case .setting:
            print("liveReadyView did click button: \(action)")
        }
    }
}
