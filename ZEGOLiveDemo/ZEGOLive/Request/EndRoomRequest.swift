//
//  EndRoomRequest.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import Foundation

struct EndRoomRequest : Request {
    var path = "/v1/room/end_room"
    var method: HTTPMethod = .POST
    typealias Response = RequestStatus
    var parameter = Dictionary<String, AnyObject>()
    
    var roomID = "" {
        willSet {
            parameter["id"] = newValue as AnyObject
        }
    }
    var type = 0 {
        willSet {
            parameter["type"] = newValue as AnyObject
        }
    }
    
    init() {
        parameter["type"] = 0 as AnyObject
    }
}
