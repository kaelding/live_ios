//
//  LiveRoomVC+FaceBeautify.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import Foundation

extension LiveRoomVC: FaceBeautifyViewDelegate {
    func configFaceBeautify() {
        RoomManager.shared.beautifyService.enableBeautify(true)
    }
    
    func beautifyValueChange(_ beautifyModel: FaceBeautifyModel) {
        RoomManager.shared.beautifyService.setBeautifyValue(Int32(beautifyModel.value), type: beautifyModel.type)
    }
}
