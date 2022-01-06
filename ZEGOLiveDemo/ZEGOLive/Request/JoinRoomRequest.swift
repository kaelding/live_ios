//
//  JoinRoomRequest.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2022/1/6.
//

import Foundation

struct JoinRoomRequest : Request {
    var path = "/v1/room/join_room"
    var method: HTTPMethod = .POST
    typealias Response = RequestStatus
    var parameter = Dictionary<String, AnyObject>()
    
    var roomID = "" {
        willSet {
            parameter["id"] = newValue as AnyObject
        }
    }
    
    var userID = "" {
        willSet {
            parameter["user_id"] = newValue as AnyObject
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
