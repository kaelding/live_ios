//
//  LiveRoomVC+Bottom.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation

extension LiveRoomVC : LiveBottomViewDelegate {
    
    func liveBottomView(_ bottomView: LiveBottomView, didClickButtonWith action: LiveBottomAction) {
        print("liveBottomView did click button: \(action)")
    }
}
