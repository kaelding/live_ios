//
//  Command.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation

enum CustomActionType : Int, Codable {
    case mic = 100
    case camera = 101
    case mute = 102
    case takeCoHostSeat = 103
    case leaveCoHostSeat = 104
    case requestToCoHost = 200
    case cancelRequestCoHost = 201
    case declineToCoHost = 202
    case agreeToCoHost = 203
}

struct CustomAction : Codable {
    var seq: Int = 0
    var type: CustomActionType?
    var targetID: String = ""
    var operatorID: String = ""
    
    enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case type = "type"
        case targetID = "targetID"
        case operatorID = "operatorID"
    }
}

class CustomCommand : NSObject, Codable {
    var roomInfo: RoomInfo?
    var seatList: [CoHostSeatModel] = []
    var coHostList: [String] = []
    var action: CustomAction?
    
    enum CodingKeys: String, CodingKey {
        case roomInfo = "roomInfo"
        case seatList = "seat"
        case coHostList = "coHost"
        case action = "action"
    }
    
    func toJson() -> String? {
        let jsonStr = ZegoJsonTool.modelToJson(toString: self)
        return jsonStr
    }
    
}
