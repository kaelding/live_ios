//
//  RoomListService.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/23.
//

import UIKit
import ZegoExpressEngine

class RoomListService: NSObject {
    
    var roomList = Array<RoomInfo>()
    
    // MARK: - Public
    func getRoomList(_ fromRoomID: String?, callback: RoomListCallback?) {
        var request = RoomListRequest()
        if let roomID = fromRoomID {
            request.from = roomID
        }
        RequestManager.shared.getRoomListRequest(request: request) { roomInfoList in
            guard let roomInfoList = roomInfoList else { return }
            if request.from.count > 0 {
                self.roomList.append(contentsOf: roomInfoList.roomInfoArray)
            } else {
                self.roomList = roomInfoList.roomInfoArray
            }
            guard let callback = callback else { return }
            callback(.success(roomInfoList.roomInfoArray))
        } failure: { roomInfoList in
            guard let callback = callback else { return }
            callback(.failure(.failed))
        }
    }
    
    func createRoom(_ roomName: String, callback: CreateRoomCallback?) {
        var request = CreateRoomRequest()
        request.name = roomName
        request.hostID = RoomManager.shared.userService.localInfo?.userID ?? ""
        
        RequestManager.shared.createRoomRequest(request: request) { status in
            guard let dataDic = status?.data else { return }
            guard let roominfo = ZegoJsonTool.dictionaryToModel(type: RoomInfo.self, dict: dataDic) else { return }
            
            guard let callback = callback else { return }
            callback(.success(roominfo))
        } failure: { requestStatus in
            guard let callback = callback else { return }
            callback(.failure(.failed))
        }
    }
}

