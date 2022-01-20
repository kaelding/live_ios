//
//  LiveRoomVC+FaceBeautify.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import Foundation

extension LiveRoomVC: FaceBeautifyViewDelegate {
    func configFaceBeautify() {
        let beautifyArray: Array<FaceBeautifyType> = [.SkinToneEnhancement, .SkinSmoothing, .ImageSharpening, .CheekBlusher, .EyesEnlarging, .FaceSliming, .MouthShapeAdjustment, .EyesBrightening, .NoseSliming, .ChinLengthening, .TeethWhitening]
        for type in beautifyArray {
            RoomManager.shared.beautifyService.enableBeautify(true, type: type)
        }
    }
    
    func beautifyValueChange(_ beautifyModel: FaceBeautifyModel) {
        RoomManager.shared.beautifyService.setBeautifyValue(Int32(beautifyModel.value), type: beautifyModel.type)
    }
}
