//
//  LiveRoomVC+FaceBeautify.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import Foundation

extension LiveRoomVC: FaceBeautifyViewDelegate {
 
    func beautifyValueChange(_ beautifyModel: FaceBeautifyModel) {
        RoomManager.shared.beautifyService.setBeautifyValue(value: Int32(beautifyModel.value), type: beautifyModel.type)
    }
}
