//
//  RoomInfoList.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import Foundation

struct RoomInfoList {
    var roomInfoArray = Array<RoomInfo>()
    var hasNextPage = false
    var requestStatus = RequestStatus(json: Dictionary<String, Any>())
    
    init() {
        
    }
    
    init(json: Dictionary<String, Any>) {
        guard let roomInfoList = json["room_list"] as? Array<String> else { return }
        roomInfoArray = roomInfoList.map{
            ZegoJsonTool.jsonToModel(type: RoomInfo.self, json: $0) ?? RoomInfo()
        }
        requestStatus = RequestStatus(json: json)
    }
}

extension RoomInfoList: Decodable {
    static func parse(_ json: Dictionary<String, Any>) -> RoomInfoList? {
        return RoomInfoList(json: json)
    }
}
